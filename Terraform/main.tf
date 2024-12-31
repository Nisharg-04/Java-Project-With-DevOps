resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "my_security_group" {
  name        = "demo-sg"
  description = "Allow user to connect via SG"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each = {
    allow_https_ipv4       = { cidr = "0.0.0.0/0", from_port = 443, to_port = 443, protocol = "tcp" }
    allow_https_ipv6       = { cidr = "::/0", from_port = 443, to_port = 443, protocol = "tcp" }
    allow_ssh              = { cidr = "0.0.0.0/0", from_port = 22, to_port = 22, protocol = "tcp" }
    allow_smtp_ipv4        = { cidr = "0.0.0.0/0", from_port = 25, to_port = 25, protocol = "tcp" }
    allow_smtp_ipv6        = { cidr = "::/0", from_port = 25, to_port = 25, protocol = "tcp" }
    allow_all_ipv4         = { cidr = "0.0.0.0/0", from_port = 3000, to_port = 10000, protocol = "tcp" }
    allow_all_ipv6         = { cidr = "::/0", from_port = 3000, to_port = 10000, protocol = "tcp" }
    allow_k8s_ipv4         = { cidr = "0.0.0.0/0", from_port = 6443, to_port = 6443, protocol = "tcp" }
    allow_k8s_ipv6         = { cidr = "::/0", from_port = 6443, to_port = 6443, protocol = "tcp" }
    allow_smtps_ipv4       = { cidr = "0.0.0.0/0", from_port = 465, to_port = 465, protocol = "tcp" }
    allow_smtps_ipv6       = { cidr = "::/0", from_port = 465, to_port = 465, protocol = "tcp" }
    allow_k8s_service_ipv4 = { cidr = "0.0.0.0/0", from_port = 30000, to_port = 32767, protocol = "tcp" }
    allow_k8s_service_ipv6 = { cidr = "::/0", from_port = 30000, to_port = 32767, protocol = "tcp" }
    allow_http             = { cidr = "0.0.0.0/0", from_port = 80, to_port = 80, protocol = "tcp" }
  }

  type              = "ingress"
  security_group_id = aws_security_group.my_security_group.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr == "0.0.0.0/0" ? [each.value.cidr] : null
  ipv6_cidr_blocks  = each.value.cidr == "::/0" ? [each.value.cidr] : null
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "demo-terra-automate-key"
  public_key = file("${path.module}/devops-key.pub")
}


# Kubernetes Instances
module "k8s_master" {
  source = "./infra"
  name   = "k8s-master"

  ami                 = "ami-0e2c8caa4b6378d8c" # Replace with appropriate AMI
  instance_type       = "t2.micro"
  security_group_name = aws_security_group.my_security_group.name
  key_name            = aws_key_pair.my_key_pair.key_name

}

module "k8s_worker_1" {
  source              = "./infra"
  name                = "k8s-worker-1"
  ami                 = "ami-0e2c8caa4b6378d8c" # Replace with appropriate AMI
  instance_type       = "t2.micro"
  security_group_name = aws_security_group.my_security_group.name
  key_name            = aws_key_pair.my_key_pair.key_name

}

module "k8s_worker_2" {
  source              = "./infra"
  name                = "k8s-worker-2"
  ami                 = "ami-0e2c8caa4b6378d8c" # Replace with appropriate AMI
  instance_type       = "t2.micro"
  security_group_name = aws_security_group.my_security_group.name
  key_name            = aws_key_pair.my_key_pair.key_name
}

# Other Instances
module "sonarqube" {
  source              = "./infra"
  name                = "sonarqube"
  ami                 = "ami-0e2c8caa4b6378d8c" # Replace with appropriate AMI
  instance_type       = "t2.micro"
  security_group_name = aws_security_group.my_security_group.name
  key_name            = aws_key_pair.my_key_pair.key_name

}

module "nexus" {
  source = "./infra"
  name   = "nexus"

  ami                 = "ami-0e2c8caa4b6378d8c" # Replace with appropriate AMI
  instance_type       = "t2.micro"
  security_group_name = aws_security_group.my_security_group.name
  key_name            = aws_key_pair.my_key_pair.key_name

}

module "jenkins" {
  source = "./infra"
  name   = "jenkins"

  ami                 = "ami-0e2c8caa4b6378d8c" # Replace with appropriate AMI
  instance_type       = "t2.micro"
  security_group_name = aws_security_group.my_security_group.name
  key_name            = aws_key_pair.my_key_pair.key_name

}
