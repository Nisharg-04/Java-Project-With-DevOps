resource "aws_instance" "ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [var.security_group_name]

  tags = {
    Name = var.name
  }
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
