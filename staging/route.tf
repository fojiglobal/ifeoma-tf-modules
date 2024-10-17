###################### Public Route Tables ######################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.all_ipv4_cidr
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.env}-public-rt"
    Environment = var.env
  }
}

###################### Private Route Tables ######################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = var.all_ipv4_cidr
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name        = "${var.env}-private-rt"
    Environment = var.env
  }
}

##### Subnet Association to Public Route Tables #####

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}

##### Subnet Association to Public Route Tables #####

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[each.key].id
}