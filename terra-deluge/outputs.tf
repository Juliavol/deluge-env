output "ansible_hosts" {
  value = "${data.template_file.ansible_hosts.rendered}"
}

# outputs
output "k8s-master-ubuntu" {
  value = ["${element(aws_instance.public-k8s-master-ubuntu.*.public_ip, 0)}", "${element(aws_instance.public-k8s-master-ubuntu.*.private_ip, 0)}"]
}

output "k8s-minions-private-ips-ubuntu" {
  value = "${aws_instance.private-k8s-minion-ubuntu.*.private_ip}"
}

output "jenkins-master-ubuntu" {
  value = ["${element(aws_instance.public-jenkins-master-ubuntu.*.public_ip, 1)}", "${element(aws_instance.public-jenkins-master-ubuntu.*.private_ip, 1)}"]
}

output "consul-master-ubuntu" {
  value = ["${element(aws_instance.public-consul-master-ubuntu.*.public_ip, 1)}", "${element(aws_instance.public-consul-master-ubuntu.*.private_ip, 1)}"]
}

//output "consul_clients" {
//  value = ["${aws_instance.consul_client.*.public_ip}"]
//}

//output "jenkins subnet" {
//  value = ["${element(aws_subnet.public.0.id)}"]
//}
