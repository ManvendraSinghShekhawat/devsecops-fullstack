variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name used in tags"
  type        = string
  default     = "devsecops-fullstack"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file (to register as AWS key pair)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  description = "EC2 instance type (free-tier: t3.micro/t2.micro)"
  type        = string
  default     = "t3.micro"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR notation (e.g., 1.2.3.4/32). Replace before apply."
  type        = string
  default     = "9.79.201.188/32"
}

variable "s3_backup_bucket" {
  description = "S3 bucket name for backups (must be globally unique). Replace with your bucket name."
  type        = string
  default     = "<S3_BUCKET_NAME>"
}
