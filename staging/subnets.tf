###################### Public Subnets ######################

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["azs"]
  tags                    = each.value["tags"]
  map_public_ip_on_launch = var.map_public_ip
}

###################### Private Subnets ######################

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["azs"]
  tags              = each.value["tags"]
}