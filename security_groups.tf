resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sec-group"
  description = "Allows SSH access from internet to the single bastion host"
  vpc_id      = var.existing_resources["vpc_id"]

  ingress {
    #get ssh access only for my IP
    cidr_blocks = ["${data.external.my_ip.result.result}/32"]
    description = "SSH access to the basion host"
    from_port   = 22
    protocol    = "tcp"
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

resource "aws_security_group" "ui_lb_sg" {
  name        = "ui-lb-sec-group"
  description = "Allows HTTP,HTTPS access from internet respectively to the ui LB"
  vpc_id      = var.existing_resources["vpc_id"]

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
      Name = "sgilz-ui-lb-sg"
    }
  )
}

resource "aws_security_group" "ui_sg" {
  name   = "ui_sec_group"
  vpc_id = var.existing_resources["vpc_id"]
  ingress {
    #get ssh access only for my IP
    cidr_blocks = ["${aws_instance.bastion.private_ip}/32"]
    description = "SSH access from the basion host"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    #get ssh access from jenkins instance
    cidr_blocks = ["${var.jenkins_private_ip}/32"]
    description = "SSH access from the jenkins host"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    {
      Name = "ui_sec_group"
    },
    var.common_tags
  )
}

resource "aws_security_group_rule" "ui_access_port" {
  from_port                = var.access_ports["ui"]
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ui_sg.id
  source_security_group_id = aws_security_group.ui_lb_sg.id
  to_port                  = var.access_ports["ui"]
  type                     = "ingress"
}

resource "aws_security_group" "api_lb_sg" {
  name        = "api-lb-sec-group"
  description = "Allows HTTP,HTTPS access from internet respectively to the api LB"
  vpc_id      = var.existing_resources["vpc_id"]

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
      Name = "sgilz-api-lb-sg"
    }
  )
}

resource "aws_security_group_rule" "http_api_lb" {
  from_port                = var.access_ports["api"]
  protocol                 = "tcp"
  security_group_id        = aws_security_group.api_lb_sg.id
  source_security_group_id = aws_security_group.ui_sg.id
  to_port                  = var.access_ports["api"]
  type                     = "ingress"
}

resource "aws_security_group" "api_sg" {
  name   = "api_sec_group"
  vpc_id = var.existing_resources["vpc_id"]
  ingress {
    #get ssh access from my IP
    cidr_blocks = ["${aws_instance.bastion.private_ip}/32"]
    description = "SSH access from the basion host"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    #get ssh access from jenkins instance
    cidr_blocks = ["${var.jenkins_private_ip}/32"]
    description = "SSH access from the jenkins host"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    {
      Name = "api_sec_group"
    },
    var.common_tags
  )
}

resource "aws_security_group_rule" "api_access_port" {
  from_port                = var.access_ports["api"]
  protocol                 = "tcp"
  security_group_id        = aws_security_group.api_sg.id
  source_security_group_id = aws_security_group.api_lb_sg.id
  to_port                  = var.access_ports["api"]
  type                     = "ingress"
}
