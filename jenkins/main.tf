resource "aws_instance" "jenkins_instance" {
  ami               = data.aws_ami.centos8.id
  availability_zone = "${var.AWS_REGION}a"
  instance_type     = var.AWS_INSTANCE_TYPE
  key_name          = var.AWS_KEY_PAIR_NAME
  private_ip        = "10.1.7.160"
  security_groups   = [aws_security_group.jenkins_sg.id]
  subnet_id         = var.existing_resources["public_subnet_0_id"]

  tags = merge(
    var.common_tags,
    {
      Name = "sgilz-jenkins"
    }
  )
  user_data   = templatefile("./templates/install_jenkins.sh.tpl", {})
  volume_tags = var.common_tags
}

resource "aws_eip" "lb" {
  instance = aws_instance.jenkins_instance.id
  vpc      = true
}
