terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ── Security Group ────────────────────────────────────────────
resource "aws_security_group" "urlshortner_sg" {
  name_prefix = "urlshortner-sg-"
  description = "Allow SSH and App traffic"

  ingress {
    description = "SSH (restricted)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }

  ingress {
    description = "HTTP (optional future use)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "urlshortner-sg"
    Environment = "dev"
    Project     = "url-shortener"
  }
}

# ── EC2 Instance ──────────────────────────────────────────────
resource "aws_instance" "urlshortner" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids      = [aws_security_group.urlshortner_sg.id]
  associate_public_ip_address = true

  # Bootstrap script
  user_data = templatefile("${path.module}/../scripts/user_data.sh", {
    app_base_url = var.app_base_url
    docker_image = var.docker_image
  })

  # Storage configuration
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  # Security best practice
  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "urlshortner-ec2"
    Environment = "dev"
    Project     = "url-shortener"
  }
}

# ── Elastic IP (static public IP) ─────────────────────────────
resource "aws_eip" "urlshortner_eip" {
  instance = aws_instance.urlshortner.id
  domain   = "vpc"

  depends_on = [aws_instance.urlshortner]

  tags = {
    Name        = "urlshortner-eip"
    Environment = "dev"
    Project     = "url-shortener"
  }
}