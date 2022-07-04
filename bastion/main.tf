data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

#Create an Instance

resource "aws_instance" "ec2_instance" {
  ami             =  data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name = aws_key_pair.deployer.id
  #key_name = "key"
  subnet_id       = var.public_subnet_id
  vpc_security_group_ids = [var.ec2_sg_group_id]
  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data       = file("${path.module}/node.sh")

  tags = {
    Name = "${var.name}-${var.environment}-bastion"
  }
  root_block_device {
    volume_size = 10
  }
  
}

resource "aws_key_pair" "deployer" { 
  key_name   = "${var.name}-deployer-key"
  public_key = tls_private_key.pem.public_key_openssh
}

resource "tls_private_key" "pem" { 
  algorithm   = "RSA"
  rsa_bits = "4096"
}

output "pem_key" {
  description = "PEM file for accessing instance"
  value = nonsensitive(tls_private_key.pem.private_key_pem)
  #sensitive = true
  depends_on = [
    aws_key_pair.deployer
  ]
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}