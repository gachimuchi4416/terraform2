resource "aws_vpc" "walter" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "walter-vpc"
  }
}

#パブリックサブネット1aを作成
resource "aws_subnet" "public_0" {
  vpc_id                  = aws_vpc.walter.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "walter-public-subnet-1a"
  }
}

#パブリックサブネット1acを作成
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.walter.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "walter-public-subnet-1a"
  }
}

#インターネットゲートウェイを作成
resource "aws_internet_gateway" "walter-igw" {
  vpc_id = aws_vpc.walter.id
  tags = {
    Name = "walter-igw"
  }
}

#パブリックルートテーブルの定義
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.walter.id
  tags = {
    Name = "walter-public-rt"
  }
}
#パブリックルートの定義
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.walter-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
#パブリックルートテーブルの関連付け(1a)
resource "aws_route_table_association" "public_0" {
  subnet_id      = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}

#パブリックルートテーブルの関連付け(1a)
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

#プライベートサブネット1aを作成
resource "aws_subnet" "private_0" {
  vpc_id                  = aws_vpc.walter.id
  cidr_block              = "10.0.65.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "walter-private-subnet-1a"
  }
}

#プライベートサブネット1cを作成
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.walter.id
  cidr_block              = "10.0.66.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "walter-private-subnet-1c"
  }
}

#プライベートトルートの定義(1a)
resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.walter.id
  tags = {
    Name = "walter-private-rt-1a"
  }
}

#プライベートトルートの定義(1c)
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.walter.id
  tags = {
    Name = "walter-private-rt-1c"
  }
}

#プライベートルートテーブルの関連付け(1a)
resource "aws_route_table_association" "private_0" {
  subnet_id      = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

#プライベートルートテーブルの関連付け(1c)
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}
#EIPの定義(1aに配置しているNATゲートウェイ用)
resource "aws_eip" "nat_gataway_0" {
  vpc        = true
  depends_on = [aws_internet_gateway.walter-igw]
}

#EIPの定義(1cに配置しているNATゲートウェイ用)
resource "aws_eip" "nat_gataway_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.walter-igw]
}

#NATゲートウェイの定義(1aに配置)
resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gataway_0.id
  subnet_id     = aws_subnet.public_0.id
  depends_on    = [aws_internet_gateway.walter-igw]
  tags = {
    Name = "walter-nat-gw-1a"
  }
}

#NATゲートウェイの定義(1cに配置)
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gataway_1.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.walter-igw]
  tags = {
    Name = "walter-nat-gw-1c"
  }
}

#プライベートルートの定義(1a)
resource "aws_route" "private_0" {
  route_table_id         = aws_route_table.private_0.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_0.id
  destination_cidr_block = "0.0.0.0/0"
}

#プライベートルートの定義(1c)
resource "aws_route" "private_1" {
  route_table_id         = aws_route_table.private_1.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}