# Create an aws public instance with ubuntu and consul on it
resource "aws_instance" "public-consul-master-ubuntu" {
  count                       = 1
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(aws_subnet.public.*.id, count.index)}"
  associate_public_ip_address = true
  key_name                    = "${var.aws_key_name}"
  security_groups             = ["${data.aws_security_group.default.id}", "${aws_security_group.deluge-sg-consul.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids      = ["${aws_security_group.deluge-sg-consul.id}"]

  user_data = "${element(data.template_file.consul_server.*.rendered, count.index)}"

  tags {
    Name = "tf-deluge-public-consul-${count.index}"
    consul_server = "true"
  }

  depends_on = ["aws_subnet.private", "aws_subnet.public"]
}

# Create the user-data for the Consul server
data "template_file" "consul_server" {
  count    = "${var.servers}"
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "deluge-consul-server-${count.index+1}",
     "server": true,
     "bootstrap_expect": ${var.servers},
     "ui": true,
     "client_addr": "0.0.0.0"
    EOF
  }
}

# Create the user-data for the Consul agent
data "template_file" "consul_client" {
  count    = "${var.clients}"
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "${var.consul_version}"
    config = <<EOF
     "node_name": "deluge-consul-client-${count.index+1}",
     "enable_script_checks": true,
     "server": false
    EOF
  }
}



