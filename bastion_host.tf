module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  create_key_pair = false
  key_name        = var.AWS_KEY_PAIR_NAME
  tags            = var.common_tags
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sec-group"
  description = "Allows SSH access from internet to a bastion host"
  vpc_id      = var.existing_resources["vpc_id"]

  ingress {
    #get ssh access only for my IP
    cidr_blocks = ["${data.external.my_ip.result.result}/32"]
    description = "SSH access to the basion host"
    from_port   = 22
    protocol    = "ssh"
    to_port     = 22
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    to_port          = 0
  }

  tags = merge(
    var.common_tags,
    {
      Name = "sgilz-bastion-sg"
    }
  )
}

resource "aws_instance" "bastion" {
  ami               = data.aws_ami.centos8.id
  availability_zone = "${var.AWS_REGION}a"
  instance_type     = var.AWS_INSTANCE_TYPE
  security_groups   = [aws_security_group.bastion_sg.id]
  subnet_id         = var.existing_resources["public_subnet_0_id"]

  tags = merge(
    var.common_tags,
    {
      Name = "sgilz-bastion"
    }
  )

  volume_tags = var.common_tags
}
