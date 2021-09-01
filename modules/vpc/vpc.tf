resource "aws_vpc" "medium_vpc" {
    provider = aws.current
    cidr_block       = var.vpc_cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.vpc_tag_name}-vpc-${var.environment}"
    }
}

resource "aws_subnet" "private_subnet" {
    provider = aws.current
    count = var.number_of_private_subnets
    vpc_id = aws_vpc.medium_vpc.id
    cidr_block = element(var.private_subnet_cidr_blocks, count.index)
    availability_zone = element(var.availability_zones, count.index)

    tags = {
        Name = "${var.private_subnet_tag_name}-${var.environment}"
    }
}



resource "aws_subnet" "public_subnet" {
    provider = aws.current
    count = var.number_of_public_subnets
    vpc_id = aws_vpc.medium_vpc.id
    cidr_block = element(var.public_subnet_cidr_blocks, count.index)
    availability_zone = element(var.availability_zones, count.index)

    tags = {
        Name = "${var.public_subnet_tag_name}-${var.environment}"
    }
}
# IGW
resource "aws_internet_gateway" "admin" {
    provider = aws.current
    count = 1

    vpc_id = aws_vpc.medium_vpc.id
    tags = {
        Name = "${var.public_subnet_tag_name}-${var.environment}"
    }
}


# PUBLIC Route Table to IGW
resource "aws_route_table" "public_route" {
    provider = aws.current
    count = 1

    vpc_id = aws_vpc.medium_vpc.id

    tags = {
        Name = "${var.public_subnet_tag_name}-${var.environment}"
    }

}

resource "aws_route" "public_internet_gateway" {
  provider = aws.current
  count = 1

  route_table_id         = aws_route_table.public_route[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.admin[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
    provider = aws.current
    count = var.number_of_public_subnets
    subnet_id       = element(aws_subnet.public_subnet.*.id, count.index)
    route_table_id  = aws_route_table.public_route[0].id
}

# Main Route table reconfiguration
resource "aws_main_route_table_association" "admin" {
    provider = aws.current  
    vpc_id         = aws_vpc.medium_vpc.id
    route_table_id = aws_route_table.public_route[0].id
}

# PRIVATE Route Table to IGW
resource "aws_route_table" "private_route" {
    provider = aws.current
    count = 1

    vpc_id = aws_vpc.medium_vpc.id

    tags = {
        Name = "${var.private_subnet_tag_name}-${var.environment}"
    }
}

resource "aws_route_table_association" "private" {
    provider = aws.current
    count           = var.number_of_private_subnets
    subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
    route_table_id  = aws_route_table.private_route[0].id
}

# To NAT

resource "aws_route" "nat_gateway" {
    provider = aws.current
    count                   = 1
    route_table_id          = element(aws_route_table.private_route.*.id, count.index)
    destination_cidr_block  = "0.0.0.0/0"
    nat_gateway_id          = element(aws_nat_gateway.admin.*.id, count.index)
}


resource "aws_security_group" "lb" {
  provider = aws.current
  name        = "${var.security_group_lb_name}-${var.environment}"
  description = var.security_group_lb_description
  vpc_id      = aws_vpc.medium_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8000
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  provider = aws.current
  name        = "${var.security_group_ecs_tasks_name}-${var.environment}"
  description = var.security_group_ecs_tasks_description
  vpc_id      = aws_vpc.medium_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [
      aws_vpc_endpoint.s3.prefix_list_id
    ]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}