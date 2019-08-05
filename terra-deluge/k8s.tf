data "template_file" "ansible_hosts" {
  template = "${file("../ansible/ansible_hosts")}"

  vars {
    jenkins_master = "${element(aws_instance.public-jenkins-master-ubuntu.*.private_ip, 1)}"
    k8s_minion_1   = "${aws_instance.private-k8s-minion-ubuntu.0.private_ip}"
    k8s_minion_2   = "${aws_instance.private-k8s-minion-ubuntu.1.private_ip}"
    consul_master  = "${element(aws_instance.public-consul-master-ubuntu.*.private_ip, 1)}"
  }
}
data "template_file" "helm-consul-yaml" {
  template = "${file("./templates/values.yml.tpl")}"

  vars {
    consul-master = "${element(aws_instance.public-consul-master-ubuntu.*.public_ip, 1)}"
  }
}

# Create an aws public instance with ubuntu on it
resource "aws_instance" "public-k8s-master-ubuntu" {
  count                       = 1
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.medium"
  subnet_id                   = "${element(aws_subnet.public.*.id, count.index)}"
  associate_public_ip_address = true
  key_name                    = "${var.aws_key_name}"
//  iam_instance_profile        = "deluge-jenkins-ec2-dynamic-slaves"
//  vpc_security_group_ids      = "${aws_security_group.vpc-deluge-sg-default.id}"


  security_groups = ["${data.aws_security_group.default.id}", "${aws_security_group.vpc-deluge-sg-default.id}"]

  //  ssh keys
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

  //provision ansible hosts
  provisioner "file" {
    content     = "${data.template_file.ansible_hosts.rendered}"
    destination = "~/ansible_hosts"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }

  provisioner "file" {
    source     = "./templates/rbac_config.yaml"
    destination = "~/rbac_config.yaml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }


//  helm-consul
  provisioner "file" {
    content     = "${data.template_file.helm-consul-yaml.rendered}"
    destination = "/tmp/values.yaml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }

//   ansible folder
  provisioner "file" {
    source      = "../ansible"
    destination = "~/ansible"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }

    script = "./scripts/k8s_ansible_init.sh"

  }

  //  helm install consul
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.aws_key_path)}"
    }

    script = "./scripts/helm_install.sh"

  }

  user_data = <<EOF
#!/bin/bash
mkdir ~/ansible
sudo apt update
sudo apt-get install ansible -y
sudo apt-get install python3.6 -y
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
export ANSIBLE_HOST_KEY_CHECKING=False

EOF

  tags {
    Name = "tf-deluge-public-k8s-master-${count.index}"
    KubernetesCluster = "foaas"
    Kubernetes_master = "yes"
    ansible_master = "yes"
  }

  depends_on = ["aws_instance.private-k8s-minion-ubuntu"]

}




