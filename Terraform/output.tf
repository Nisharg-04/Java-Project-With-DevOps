output "key_pair_name" {
  value = aws_key_pair.my_key_pair.key_name

}
output "security_group_name" {
  value = aws_security_group.my_security_group.name

}
output "k8s_master_ip" {
  value = module.k8s_master.public_ip
}

output "k8s_worker_1_ip" {
  value = module.k8s_worker_1.public_ip
}

output "k8s_worker_2_ip" {
  value = module.k8s_worker_2.public_ip
}

output "sonarqube_ip" {
  value = module.sonarqube.public_ip
}

output "nexus_ip" {
  value = module.nexus.public_ip
}

output "jenkins_ip" {
  value = module.jenkins.public_ip
}
