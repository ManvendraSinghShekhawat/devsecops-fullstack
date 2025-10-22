variable "region" { type = string; default = "eu-west-1" }
variable "project_name" { type = string; default = "devsecops-fullstack" }
variable "ssh_public_key_path" { type = string; default = "~/.ssh/id_rsa.pub" }
variable "instance_type" { type = string; default = "t3.micro" }
variable "my_ip_cidr" { type = string; default = "9.79.201.188/32" }
