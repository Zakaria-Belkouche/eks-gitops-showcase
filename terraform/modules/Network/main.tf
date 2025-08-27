resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  tags                 = local.tags
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  for_each          = var.privatesubnet_cidrs
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = var.subnet_az[each.key]
  tags = merge(local.tags, {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/eks"       = "shared"
  })
}

resource "aws_subnet" "public" {
  for_each                = var.publicsubnet_cidrs
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_az[each.key]
  tags = merge(local.tags, {
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/eks" = "shared"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}

resource "aws_eip" "elastic_ip" {
  domain = "vpc"
  tags   = local.tags
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public["subnet_1"].id
  depends_on    = [aws_eip.elastic_ip]
  tags          = local.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = local.tags
}

resource "aws_route_table_association" "public_route" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = local.tags
}

resource "aws_route_table_association" "private_route" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

