resource "aws_s3_bucket" "data_vpc_data" {
  bucket = "data-vpc-data"

  tags = {
    Name        = "database_peer"
    Environment = "infrastructure"
  }
}

resource "aws_vpc" "arena" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "arena"
    environment = "staging"
    project = "gaming"
  }
}

resource "aws_subnet" "arena_public_subnet" {
  vpc_id     = aws_vpc.arena.id
  cidr_block = "10.0.1.0/24"

  tags = {
   Name = "arena"
    environment = "staging"
    project = "gaming"
  }
}

resource "aws_internet_gateway" "arena_gw" {
  vpc_id = aws_vpc.arena.id
}

resource "aws_security_group" "arena_allow" {
  name        = "arena_allow"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.arena.id

  tags = {
    Name = "arena"
    environment = "staging"
    project = "gaming"
}
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.arena_allow.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.arena_allow.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_route_table" "arena_route" {
  vpc_id = aws_vpc.arena.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.arena_gw.id
}
}
resource "aws_route_table_association" "arena_game" {
  subnet_id      = aws_subnet.arena_public_subnet.id
  route_table_id = aws_route_table.arena_route.id
}



resource "aws_vpc" "quest" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "quest"
    environment = "development"
    project = "gaming"
  }
}

resource "aws_subnet" "quest_private_subnet" {
  vpc_id     = aws_vpc.quest.id
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "quest"
    environment = "development"
    project = "gaming"
  }
}

resource "aws_internet_gateway" "quest_gw" {
  vpc_id = aws_vpc.quest.id
}

resource "aws_security_group" "quest_allow" {
  name        = "quest_allow"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.quest.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_quest_id" {
  security_group_id = aws_security_group.quest_allow.id
  cidr_ipv4         = aws_vpc.quest.cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_quest" {
  security_group_id = aws_security_group.quest_allow.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_route_table" "quest_route" {
  vpc_id = aws_vpc.quest.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.quest_gw.id
}
}
resource "aws_route_table_association" "quest_game" {
  subnet_id      = aws_subnet.quest_private_subnet.id
  route_table_id = aws_route_table.quest_route.id
}

resource "aws_vpc_peering_connection" "arena_quest" {
  peer_vpc_id   = aws_vpc.arena.id
  vpc_id        = aws_vpc.quest.id
}

# Arena route to reach Quest
resource "aws_route" "arena_to_quest" {
  route_table_id         = aws_route_table.arena_route.id
  destination_cidr_block = aws_vpc.quest.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.arena_quest.id
}

# Quest route to reach Arena
resource "aws_route" "quest_to_arena" {
  route_table_id         = aws_route_table.quest_route.id
  destination_cidr_block = aws_vpc.arena.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.arena_quest.id
}
