variable "aws_key_path" {
  type    = "string"
  default = "/home/julia/.ssh/Session3_jenkins_keyPair.pem"
}


variable "aws_key_name" {
  type    = "string"
  default = "Session3_jenkins_keyPair"
}

variable "aws_key_path_pub" {
  type    = "string"
  default = "/home/julia/.ssh/Session3_jenkins_keyPair.pub"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "servers" {
  description = "The number of consul servers."
  default = 1
}

variable "clients" {
  description = "The number of consul client instances"
  default = 2
}

variable "consul_version" {
  description = "The version of Consul to install (server and client)."
  default     = "1.4.0"
}


variable "ami" {
  description = "ami to use - based on region"
  default = {
    "us-east-1" = "ami-0565af6e282977273"
    "us-east-2" = "ami-0653e888ec96eab9b"
  }
}
variable "jenkins_ami" {
  description = "ami to use - based on region"
  default = "ami-0ef62b8097bad8702" #new jenkins ami 27-04-19
}

variable "dockerhub_username" {
  type    = "string"

}
variable "dockerhub_password" {
  type = "string"
}

variable "jenkins_admin_user" {
  type    = "string"

}
variable "jenkins_admin_password" {
  type = "string"
}

