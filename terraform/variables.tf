variable "region" {
  type    = string
  default = "us-east-1"  # 
  
  
}

variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidr" { default = "10.0.1.0/24" }

variable "ssh_public_key_path" {
  description = "Path to the public key file for EC2"
  type        = string
  default     = "~/.ssh/jenkins_ansible_ec2.pub"
}


variable "instance_ami" {
  description = "AMI id"
  type = string
  default = "ami-0ecb62995f68bb549" # remplir via -var ou Jenkins params
}

variable "instance_type" { default = "t3.micro" }
