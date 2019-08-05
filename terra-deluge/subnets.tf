resource "aws_subnet" "private" {
  count             = "2"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block        = "${cidrsubnet(aws_vpc.deluge-VPC.cidr_block, 8, count.index)}"
  vpc_id            = "${aws_vpc.deluge-VPC.id}"

  tags = {
    Name = "tf-cluster-1-private-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_subnet" "public" {
  count                   = "2"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block              = "${cidrsubnet(aws_vpc.deluge-VPC.cidr_block, 8, count.index + length(data.aws_availability_zones.available.names))}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.deluge-VPC.id}"


  tags = {
    Name = "tf-cluster-1-public-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}
