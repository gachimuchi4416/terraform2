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