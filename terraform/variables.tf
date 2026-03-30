variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 (Amazon Linux)"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Existing AWS key pair name for SSH access"
  type        = string
}

variable "your_ip_cidr" {
  description = "Your public IP in CIDR format (for SSH access)"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/32$", var.your_ip_cidr))
    error_message = "Must be a valid IP in /32 CIDR format (e.g., 203.0.113.5/32)."
  }
}

variable "docker_image" {
  description = "Docker image to deploy on EC2"
  type        = string
}

variable "app_base_url" {
  description = "Base URL of the application (used inside container if needed)"
  type        = string
  default     = ""
}