#!/bin/bash
set -e

# ─────────────────────────────────────────────
# deploy.sh — Build → Push → Terraform Apply
# Usage: ./deploy.sh <dockerhub-username>
# ─────────────────────────────────────────────

DOCKER_USER=${1:?"Usage: ./deploy.sh <dockerhub-username>"}
IMAGE="$DOCKER_USER/urlshortner:latest"

echo "🚀 Starting deployment..."

# ── CHECK DOCKER ─────────────────────────────
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker is not running. Start Docker Desktop."
  exit 1
fi

# ── CHECK MAVEN BUILD ────────────────────────
echo "📦 Building JAR..."
mvn clean package

if [ ! -f "target/urlshortner-0.0.1-SNAPSHOT.jar" ]; then
  echo "❌ JAR not found. Build failed."
  exit 1
fi

# ── BUILD IMAGE ──────────────────────────────
echo "🐳 Building Docker image: $IMAGE"
docker build -t "$IMAGE" .

# ── PUSH IMAGE ───────────────────────────────
echo "📤 Pushing to Docker Hub..."
docker push "$IMAGE"

# ── TERRAFORM DEPLOY ─────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/terraform"

echo "🌍 Running Terraform..."

terraform init -input=false

terraform apply \
  -var="docker_image=$IMAGE" \
  -auto-approve

# ── OUTPUT ───────────────────────────────────
echo ""
echo "🎉 Deployment complete!"

terraform output

echo ""
echo "🌐 Try opening your app:"
terraform output -raw app_url