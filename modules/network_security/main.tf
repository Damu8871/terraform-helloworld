resource "aws_vpc" "test_vpc"{
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "${var.tenancy}"
  tags {
    Name = "${var.tagname_vpc}"
  }
}


data "aws_availability_zones" "available" {}


resource "aws_subnet" "publicsubnet"{
  count = "${var.azs_count}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.test_vpc.cidr_block, 8, count.index)}"
  tags {
    Name = "${var.tagname_subnet}"
  }
}

resource "aws_subnet" "privatesubnet"{
  count = "${var.azs_count}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.test_vpc.cidr_block, 8, count.index+4)}"
  tags {
	Name = "private subnet"
  }

}

resource "aws_internet_gateway" "IGW" {
  vpc_id = "${aws_vpc.test_vpc.id}"
}


resource "aws_eip" "eip_nat" {
  vpc = true
  depends_on = ["aws_internet_gateway.IGW"]
}



resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = "${aws_eip.eip_nat.id}"
  subnet_id = "${aws_subnet.publicsubnet.0.id}"
  tags{
	Name = "Nat Gateway"
  }
}



resource "aws_route_table" "Public_RT" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  route{
	cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.IGW.id}"
  }
}

resource "aws_route_table" "Private_RT" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  route{
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.NAT_GW.id}"
  }
}

resource "aws_route_table_association" "Public_RT_IG" {
  count = "${var.azs_count}"
  subnet_id = "${element(aws_subnet.publicsubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.Public_RT.id}"
}

resource "aws_route_table_association" "Private_RT_IG" {
  count = "${var.azs_count}"
  subnet_id = "${element(aws_subnet.privatesubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.Private_RT.id}"
}

