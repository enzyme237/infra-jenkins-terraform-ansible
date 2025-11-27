resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = { Name = "jenkins-tp-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "jenkins-tp-igw" }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = { Name = "jenkins-tp-public-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "jenkins-tp-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security group
resource "aws_security_group" "web_sg" {
  name        = "jenkins-tp-web-sg"
  description = "Allow SSH from your IP and HTTP from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from specific IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]  # à fournir
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "jenkins-tp-web-sg" }
}

variable "my_ip_cidr" {
  type = string
  default = "109.23.2.65/32" # remplir en Jenkins param
}

# Key pair from public key content
resource "aws_key_pair" "ansible_key" {
  key_name   = "jenkins_ansible_key"
  public_key = var.ssh_public_key
}

# EC2 instance
resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = aws_key_pair.ansible_key.key_name

  tags = { Name = "jenkins-tp-web" }
}
