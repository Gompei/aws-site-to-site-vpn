########################################################
# VPC
########################################################
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

########################################################
# Internet Gateway
########################################################
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

########################################################
# Nat Gateway
########################################################
resource "aws_eip" "nat" {
  count = 1
  vpc   = true
}
resource "aws_nat_gateway" "nat" {
  count         = 1
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat[count.index].id
}

########################################################
# Customer Gateway
########################################################
resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = "65000"
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
}

########################################################
# VPN Gateway
########################################################
resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_vpn_gateway_attachment" "vpn_gateway_attachment" {
  vpc_id         = aws_vpc.vpc.id
  vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
}

########################################################
# VPN Connection
########################################################
resource "aws_vpn_connection" "vpn_connection" {
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  type                = "ipsec.1"
}

########################################################
# Subnet
########################################################
# Public
data "aws_availability_zones" "available" {
}
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
}
resource "aws_route" "public_vpn_route" {
  destination_cidr_block = var.home_network_cidr
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, length(aws_subnet.public) + count.index)
}
resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route" "private" {
  count                  = 2
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}
resource "aws_route" "private_vpn_route" {
  count                  = 2
  destination_cidr_block = var.home_network_cidr
  route_table_id         = aws_route_table.private[count.index].id
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
