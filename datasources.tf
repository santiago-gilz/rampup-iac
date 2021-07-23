data "aws_ami" "centos8" {
  most_recent = true
  name_regex  = "^CentOS 8*"
  owners      = ["125523088429"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "external" "my_ip" {
  program = ["bash", "./scripts/get_my_public_ip.sh"]
}