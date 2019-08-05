
# Create an aws private instance with ubuntu  (k8s minion)  on it
resource "aws_instance" "private-k8s-minion-ubuntu" {
  count           = 2
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  subnet_id       = "${element(aws_subnet.public.*.id, count.index)}"
  key_name        = "${var.aws_key_name}"
  security_groups = ["${data.aws_security_group.default.id}"]

  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids = ["${aws_security_group.deluge-sg-consul.id}"]


  user_data = "${element(data.template_file.consul_client.*.rendered, count.index)}"

  tags {
    Name = "tf-deluge-k8s-minion-instance-${count.index}"
  }

  depends_on = ["aws_subnet.private", "aws_subnet.public"]
}
