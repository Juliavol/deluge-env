data "template_file" "jenkins_configure_ec2" {
  template = "${file("${path.module}/templates/jenkins_confgure_ec2.groovy.tpl")}"
  vars = {
    jenkins_ec2_subnet = "${aws_subnet.public.0.id}"
    jenkins_ec2_sg = "${aws_security_group.vpc-deluge-sg-default.id}"
    jenkins_ssh_key = "${file("${var.aws_key_path}")}"

  }
}
data "template_file" "jenkins_configure_ssh" {
  template = "${file("${path.module}/templates/add_ssh_credentials.groovy.tpl")}"
  vars = {
    jenkins_ssh_key = "${file("${var.aws_key_path}")}"
  }
}
data "template_file" "jenkins_configure_dockerhub_credentials" {
  template = "${file("${path.module}/templates/2_dockerhub_credentials.groovy.tpl")}"
  vars = {
    dockerhub_username = "${var.dockerhub_username}"
    dockerhub_password = "${var.dockerhub_password}"
  }
}
data "template_file" "jenkins_configure_jenkins_credentials" {
  template = "${file("${path.module}/templates/1_setup_users.groovy.tpl")}"
  vars = {
    jenkins_admin_user = "${var.jenkins_admin_user}"
    jenkins_admin_password = "${var.jenkins_admin_password}"
  }
}

# Create an aws public instance with ubuntu and jenkins on it
resource "aws_instance" "public-jenkins-master-ubuntu" {

//  ami                         = "${var.jenkins_ami}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.micro"
  subnet_id                   = "${aws_subnet.public.0.id}"
  associate_public_ip_address = true
  key_name                    = "${var.aws_key_name}"
//  security_groups             = ["${aws_security_group.vpc-deluge-default.id}"]
  iam_instance_profile        = "deluge-jenkins-ec2-dynamic-slaves"
  vpc_security_group_ids      = ["${aws_security_group.deluge-sg-consul.id}","${aws_security_group.vpc-deluge-sg-default.id}"]

  provisioner "file" {
    source      = "${var.aws_key_path}"
    destination = "~/.ssh/id_rsa"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }
  provisioner "file" {
    source      = "${var.aws_key_path_pub}"
    destination = "~/.ssh/id_rsa.pub"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }

  #switch to userdata / ansible
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }

    script = "./scripts/install_jenkins.sh"

  }

  provisioner "file" {
    content     = "${data.template_file.jenkins_configure_ec2.rendered}"
    destination = "/tmp/jenkins_configure.ec2.groovy"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }
  provisioner "file" {
    content     = "${data.template_file.jenkins_configure_dockerhub_credentials.rendered}"
    destination = "/tmp/2_dockerhub_credentials.groovy"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }

  provisioner "file" {
    content     = "${data.template_file.jenkins_configure_jenkins_credentials.rendered}"
    destination = "/tmp/1_setup_users.groovy"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }

  provisioner "file" {
    content     = "${data.template_file.jenkins_configure_ssh.rendered}"
    destination = "/tmp/jenkins_configure_ssh.groovy"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }

  provisioner "file" {
    source      = "./init.groovy.d"
    destination = "/tmp/init.groovy.d"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }


//  switch to userdata / ansible
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }

    script = "./scripts/restart_jenkins.sh"

  }

  tags {
    Name = "tf-deluge-public-jenkins-1"
  }

  depends_on = ["aws_subnet.private", "aws_subnet.public"]

}






