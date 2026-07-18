# 1. Configure the cloud provider to connect to AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2" # Sets deployment data center to Sydney for low latency
}

# 2. Create a secure firewall rule (Security Group) allowing web traffic
resource "aws_security_group" "kiosk_sg" {
  name        = "kiosk-web-traffic-rules"
  description = "Allow HTTP web traffic to our restaurant kiosk"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open port 80 to the public web
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow server to talk out to the internet
  }
}

# 3. Provision a tiny, free-tier eligible virtual machine (EC2 Instance)
resource "aws_instance" "kiosk_server" {
  ami           = "ami-00712dae9a53f656d" # Standard Ubuntu 24.04 LTS Image for Sydney region
  instance_type = "t2.micro"             # Free-tier compute unit
  
  vpc_security_group_ids = [aws_security_group.kiosk_sg.id]

  tags = {
    Name = "hospitality-kiosk-production-server"
  }
}

# 4. Output the public IP address once the server is built
output "kiosk_public_ip" {
  value       = aws_instance.kiosk_server.public_ip
  description = "The live public IP address of your new restaurant server"
}