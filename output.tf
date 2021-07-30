output "found-ami" {
  value = data.aws_ami.centos8.name
}

output "key_pair_name" {
  value = var.AWS_KEY_PAIR_NAME
}

output "bastion-dns" {
  value = aws_instance.bastion.public_dns
}

output "internal-api-dns-name" {
  value = module.api_elb.elb_dns_name
}

output "ui-dns-name" {
  value = module.ui_elb.elb_dns_name
}
