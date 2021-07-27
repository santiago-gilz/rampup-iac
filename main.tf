resource "aws_instance" "bastion" {
  ami               = data.aws_ami.centos8.id
  availability_zone = "${var.AWS_REGION}a"
  instance_type     = var.AWS_INSTANCE_TYPE
  key_name          = var.AWS_KEY_PAIR_NAME
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
