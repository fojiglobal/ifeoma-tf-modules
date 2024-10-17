###################### Private SG ######################
resource "aws_security_group" "private" {
  name        = "${var.env}-private-sg"
  description = "Private Security Group"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.env}-private-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "prv_sg_ingress" {
  for_each = var.private_sg_ingress

  security_group_id            = aws_security_group.private.id
  referenced_security_group_id = each.value["src"]
  from_port                    = each.value["from_port"]
  to_port                      = each.value["to_port"]
  ip_protocol                  = each.value["ip_protocol"]
  description                  = each.value["description"]
}

resource "aws_vpc_security_group_egress_rule" "prv_sg_egress" {
  for_each = var.private_sg_egress

  security_group_id = aws_security_group.private.id
  cidr_ipv4         = each.value["dest"]
  ip_protocol       = each.value["ip_protocol"]
  description       = each.value["description"]
}

###################### Public SG ######################

resource "aws_security_group" "public" {
  name        = "${var.env}-public-sg"
  description = "Public Security Group"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.env}-public-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "pub_sg_ingress" {
  for_each = var.public_sg_ingress

  security_group_id = aws_security_group.public.id
  cidr_ipv4         = each.value["src"]
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  ip_protocol       = each.value["ip_protocol"]
  description       = each.value["description"]
}

resource "aws_vpc_security_group_egress_rule" "pub_sg_egress" {
  for_each = var.public_sg_egress

  security_group_id = aws_security_group.public.id
  cidr_ipv4         = each.value["dest"]
  ip_protocol       = each.value["ip_protocol"]
  description       = each.value["description"]
}

###################### Bastion SG ######################

resource "aws_security_group" "bastion" {
  name        = "${var.env}-bastion-sg"
  description = "Bastion Security Group"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.env}-bastion-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_sg_ingress" {
  for_each = var.bastion_sg_ingress

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = each.value["src"]
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  ip_protocol       = each.value["ip_protocol"]
  description       = each.value["description"]
}

resource "aws_vpc_security_group_egress_rule" "bastion_sg_egress" {
  for_each = var.bastion_sg_egress

  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = each.value["dest"]
  ip_protocol       = each.value["ip_protocol"]
  description       = each.value["description"]
}