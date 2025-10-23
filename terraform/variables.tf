variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Prefix used for resource naming"
  type        = string
  default     = "devsecops-fullstack"
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR format for SSH access"
  type        = string
  default     = "9.79.201.188/32"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t3.micro"
}
