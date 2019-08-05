#Create two VPCs (private and public) - remember to update the security group not to allow all traffic everywhere
# Setup the region in which to work.
provider "aws" {
  region = "${var.aws_region}"
}

# Create a VPC
resource "aws_vpc" "deluge-VPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "tf-cluster-foass"
  }
}

# Grab the list of availability zones
data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.deluge-VPC.id}"

  tags {
    Name = "tf-cluster-1-main-gw"
  }
}

# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "deluge-consul-join"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

# Create an IAM role for the kubernetes master
resource "aws_iam_role" "k8s-master" {
  name               = "deluge-k8s-master_iam_role"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}
# Create an IAM role for the kubernetes minion
resource "aws_iam_role" "k8s-minion" {
  name               = "deluge-k8s-minion-iam-role"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

resource "aws_iam_role" "jenkins-ec2-full" {
  name               = "deluge-jenkins-ec2-full-iam-role"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

# Create an IAM policy
resource "aws_iam_policy" "consul-join" {
  name        = "deluge-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = "${file("${path.module}/templates/policies/describe-instances.json")}"
}

# Create an IAM policy
resource "aws_iam_policy" "jenkins-ec2-dynamic-slaves" {
  name        = "deluge-jenkins-ec2-dynamic-slaves"
  description = "Allows Jenkins nodes to create dynamic slaves"
  policy      = "${file("${path.module}/templates/policies/ec2-full-access.json")}"
}

# Create an IAM policy
resource "aws_iam_policy" "k8s-master-policy" {
  name        = "deluge-k8s-master-policy"
  description = "allows k8s to create aws resources"
  policy      = "${file("${path.module}/templates/policies/k8s-master-policy.json")}"
}

# Create an IAM policy
resource "aws_iam_policy" "k8s-minion-policy" {
  name        = "deluge-k8s-minion-policy"
  description = "Allows K8s minions to connect to aws resources"
  policy      = "${file("${path.module}/templates/policies/k8s-minion-policy.json")}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "jenkins-ec2-dynamic-slaves" {
  name       = "deluge-jenkins-ec2-dynamic-slaves"
  roles      = ["${aws_iam_role.jenkins-ec2-full.name}"]
  policy_arn = "${aws_iam_policy.jenkins-ec2-dynamic-slaves.arn}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "deluge-consul-join"
  roles      = ["${aws_iam_role.consul-join.name}"]
  policy_arn = "${aws_iam_policy.consul-join.arn}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "k8s-master-join" {
  name       = "deluge-consul-join"
  roles      = ["${aws_iam_role.k8s-master.name}"]
  policy_arn = "${aws_iam_policy.k8s-master-policy.arn}"
}
# Attach the policy
resource "aws_iam_policy_attachment" "k8s-minion-join" {
  name       = "deluge-consul-join"
  roles      = ["${aws_iam_role.k8s-minion.name}"]
  policy_arn = "${aws_iam_policy.k8s-minion-policy.arn}"
}


# Create the instance profile
resource "aws_iam_instance_profile" "deluge-consul-join-instance-profile" {
  name  = "deluge-consul-join"
  role = "${aws_iam_role.consul-join.name}"
}

# Create the instance profile
resource "aws_iam_instance_profile" "deluge-jenkins-ec2-dynamic-slaves-instance-profile" {
  name  = "deluge-jenkins-ec2-dynamic-slaves"
  role = "${aws_iam_role.jenkins-ec2-full.name}"
}

# Create the instance profile
resource "aws_iam_instance_profile" "deluge-k8s-master-instance-profile" {
  name  = "deluge-k8s-master-instance-profile"
  role = "${aws_iam_role.k8s-master.name}"
}
# Create the instance profile
resource "aws_iam_instance_profile" "deluge-k8s-minion-instance-profile" {
  name  = "deluge-k8s-minion-instance-profile"
  role = "${aws_iam_role.k8s-minion.name}"
}


