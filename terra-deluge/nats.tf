resource "aws_eip" "nat" {
  count      = "2"
  vpc        = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_nat_gateway" "gw" {
  count         = "2"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  tags {
    Name = "NAT tf-cluster-1 ${element(aws_subnet.public.*.availability_zone, count.index)}"
  }

  depends_on = ["aws_eip.nat"]
}

resource "aws_route_table" "public" {
  count  = "2"
  vpc_id = "${aws_vpc.deluge-VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "public tf-cluster-1 ${element(aws_subnet.public.*.availability_zone, count.index)}"
  }
}

resource "aws_route_table" "private" {
  count  = "2"
  vpc_id = "${aws_vpc.deluge-VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_nat_gateway.gw.*.id, count.index)}"
  }

  tags {
    Name = "private tf-cluster-1 ${element(aws_subnet.public.*.availability_zone, count.index)}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "2"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

resource "aws_route_table_association" "private" {
  count          = "2"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
