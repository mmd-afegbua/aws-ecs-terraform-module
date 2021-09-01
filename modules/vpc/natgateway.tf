# NAT Gateway for private subnets
resource "aws_nat_gateway" "admin" {
    count           = 1
    subnet_id       = element(aws_subnet.public_subnet.*.id, count.index)
    allocation_id   = element(aws_eip.admin.*.id, count.index)

    tags = {
        "Name" = "admin-tools-ngw-${element(var.availability_zones, count.index)}"
    }
}

resource "aws_eip" "admin" {
    count   = 1
    vpc     = true
}