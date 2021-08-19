output "jenkins-ssh-access" {
  value = "ssh -i ../sgilz-key-pair centos@${aws_instance.jenkins_instance.public_dns}"
}

output "jenkins-dns-name" {
  value = "${aws_instance.jenkins_instance.public_dns}"
}
