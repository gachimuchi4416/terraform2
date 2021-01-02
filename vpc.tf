resource "aws_vpc" "walter" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "walter-vpc"
  }
}

#パブリックサブネットを作成
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.walter.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

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

#ルートテーブルの定義
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.walter.id
  tags = {
    Name = "walter-public-rt"
  }
}
#ルートの定義
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.walter-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
#ルートテーブルの関連付け
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}