#Create Instance Security Group
resource "aws_security_group" "ec2_sg_group" {
  description = "Bastion Host"
  name_prefix = "${var.name}-${var.environment}-bastion-"
  vpc_id      = var.vpc

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-${var.environment}-bastion_sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "ec2_sg_group_id" {
  value = aws_security_group.ec2_sg_group.id
}