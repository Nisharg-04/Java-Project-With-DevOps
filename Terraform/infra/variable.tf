variable "name" {
  description = "This is name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "This is the Instance Type for AWS EC2 eg. t2.micro/t2.medium/t2.small"
  type        = string
}



variable "ami" {
  description = "This is the AMI ID for EC2 instance"
  type        = string
}



variable "key_name" {
  description = "This is the key name for the EC2 instance"
  type        = string
}

variable "security_group_name" {
  description = "This is the security group id for the EC2 instance"
  type        = string

}
