output "found-ami" {
  value = data.aws_ami.centos8.name
}

output "bastion-dns" {
  value = aws_instance.bastion.public_dns
}
