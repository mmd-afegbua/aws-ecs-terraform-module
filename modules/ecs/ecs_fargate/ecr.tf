resource "aws_ecr_repository" "main" {
provider = aws.current

name = "${var.cluster_name}_${var.environment}"

image_scanning_configuration {

  scan_on_push = var.scan_on_push

  }
}