resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sec-group"
  description = "Allows SSH access from internet to the jenkins host"
  vpc_id      = var.existing_resources["vpc_id"]

  ingress {
    #get ssh access only for my IP
    cidr_blocks = ["${data.external.my_ip.result.result}/32"]
    description = "SSH access to the jenkins host"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    #get HTTP access  from anywhere (needed for the UI interface and GitHub webhooks)
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access to the jenkins host"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
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
      Name = "sgilz-jenkins-sg"
    }
  )
}
