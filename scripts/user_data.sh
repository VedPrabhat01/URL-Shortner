#!/bin/bash
set -e

# ── LOGGING ───────────────────────────────────────────────────
exec > /var/log/user-data.log 2>&1
echo "🚀 Starting user_data script..."

# ── SYSTEM UPDATE ─────────────────────────────────────────────
yum update -y

# ── INSTALL DOCKER ────────────────────────────────────────────
echo "📦 Installing Docker..."

yum install -y docker || amazon-linux-extras install docker -y

systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# ── WAIT FOR DOCKER TO BE READY ───────────────────────────────
echo "⏳ Waiting for Docker daemon..."

for i in {1..20}; do
  if docker info > /dev/null 2>&1; then
    echo "✅ Docker is ready!"
    break
  fi
  echo "  attempt $i — still waiting..."
  sleep 3
done

# Safety check (important)
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker failed to start"
  exit 1
fi

# ── PULL DOCKER IMAGE ─────────────────────────────────────────
echo "📥 Pulling Docker image: ${docker_image}"
docker pull "${docker_image}"

# ── CLEAN OLD CONTAINER ───────────────────────────────────────
echo "🧹 Removing old container if exists..."
docker rm -f urlshortner-container || true

# ── RUN CONTAINER ─────────────────────────────────────────────
echo "🚀 Starting container..."

docker run -d \
  --name urlshortner-container \
  -p 8080:8080 \
  -e APP_BASE_URL="${app_base_url}" \
  --restart always \
  "${docker_image}"

# ── VERIFY CONTAINER ──────────────────────────────────────────
sleep 5

if docker ps | grep urlshortner-container; then
  echo "✅ Container is running successfully!"
else
  echo "❌ Container failed to start"
  docker logs urlshortner-container
  exit 1
fi

echo "🎉 Deployment complete!"