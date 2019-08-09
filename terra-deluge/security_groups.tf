data "aws_security_group" "default" {
  vpc_id = "${aws_vpc.deluge-VPC.id}"
  name   = "default"
}

resource "aws_security_group" "vpc-deluge-sg-default" {
  name        = "deluge-sg-default"
  description = "default VPC deluge security group"
  vpc_id      = "${aws_vpc.deluge-VPC.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    KubernetesCluster = "deluge-k8s-cluster"
  }

}

resource "aws_security_group" "deluge-sg-consul" {
  name        = "deluge-sg-consul"
  description = "Allow ssh & consul inbound traffic"
  vpc_id      = "${aws_vpc.deluge-VPC.id}"



  ingress {
    from_port = 8301
    protocol = "tcp"
    to_port = 8301
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh from the world"
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow all outside security group"
  }
}

resource "aws_security_group" "deluge-sg-prometheus" {
  name = "foaas-prometheus"
  description = "Allow ssh & consul inbound traffic"
  vpc_id = "${aws_vpc.deluge-VPC.id}"
  //  exposed_ports = [3000, 9090, 9093, 9100, 8080, 5000, 9000]
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
    description = "Allow all inside security group"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow ssh from the world"
  }

  ingress {
    from_port = 3000
    protocol = "tcp"
    to_port = 3000
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }

  ingress {
    from_port = 9090
    to_port = 9090
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }

  ingress {
    from_port = 9093
    to_port = 9093
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }
  #node exporter
  ingress {
    from_port = 9100
    to_port = 9100
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }

  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }

  ingress {
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "Allow all outside security group"
  }
}


resource "aws_security_group" "deluge-k8s-sg" {
  name = "foaas-k8s-sg"
  description = "Allow ssh & consul inbound traffic"
  vpc_id = "${aws_vpc.deluge-VPC.id}"

    ingress {
    from_port   = 6666
    to_port     = 6666
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 9153
    to_port     = 9153
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 32000
    to_port     = 32000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 30000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "deluge-jenkins-sg" {
  name = "foaas-jenkins-sg"
  description = "Allow ssh & consul inbound traffic"
  vpc_id = "${aws_vpc.deluge-VPC.id}"

    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "foaas-jenkins-sg"
  }

}
