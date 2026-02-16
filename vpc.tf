resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main VPC"
  }
}


# create an elastic ip for nat gateway
resource "aws_eip" "nat_eip_1b" {
  domain = "vpc"

  tags = {
    Name = "NAT Gateway EIP"
  }
}

resource "aws_eip" "nat_eip_1c" {
  domain = "vpc"

  tags = {
    Name = "NAT Gateway EIP"
  }
}

# Create an Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main Internet Gateway"
  }
}


# Create a Public Subnet
resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1b"
  }

}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1c"
  }
}


# create a route table for public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# associate public subnets with public route table
resource "aws_route_table_association" "public_rt_1b_assoc" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_1c_assoc" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_rt.id
}

# create two private subnets
resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private Subnet 1b"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "Private Subnet 1c"
  }
}

# create a database subnet
resource "aws_subnet" "database_subnet_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Database Subnet 1b"
  }
}

# Create a NAT Gateway in the private subnet 1b
resource "aws_nat_gateway" "nat_eip_1b" {
  allocation_id = aws_eip.nat_eip_1b.id
  subnet_id     = aws_subnet.public_subnet_1b.id

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_eip_1c" {
  allocation_id = aws_eip.nat_eip_1c.id
  subnet_id     = aws_subnet.public_subnet_1c.id

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "database_subnet_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "Database Subnet 1c"
  }
}


# Create a Private Route Table
resource "aws_route_table" "private_rt_1b" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_eip_1b.id
  }
  tags = {
    Name = "Private Route Table 1b"
  }
}

# attaching route to a private subnet
resource "aws_route_table_association" "private_rt_1b_assoc" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_rt_1b.id
}


resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_eip_1c.id
  }
  tags = {
    Name = "Private Route Table 1c"
  }
}

# attaching route to a private subnet
resource "aws_route_table_association" "private_rt_1c_assoc" {
  subnet_id      = aws_subnet.private_subnet_1c.id
  route_table_id = aws_route_table.private_rt_1c.id
}
