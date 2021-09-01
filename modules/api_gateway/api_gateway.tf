resource "aws_api_gateway_rest_api" "admin_tool" {
    name = "api-gateway-${var.cluster_name}"
}

resource "aws_api_gateway_resource" "admin_tool" {
    rest_api_id = aws_api_gateway_rest_api.admin_tool.id
    parent_id = aws_api_gateway_rest_api.admin_tool.root_resource_id  
    path_part = var.path_part
}

resource "aws_api_gateway_method" "admin_tool" {
    rest_api_id = aws_api_gateway_rest_api.admin_tool.id
    resource_id =  aws_api_gateway_resource.admin_tool.id
    http_method = "ANY"
    authorization = "NONE"

    request_parameters = {
      "method.request.path.proxy" = true
    }
}

resource "aws_api_gateway_integration" "admin_tool" {
    rest_api_id = aws_api_gateway_rest_api.admin_tool.id
    resource_id = aws_api_gateway_resource.admin_tool.id  
    http_method = aws_api_gateway_method.admin_tool.http_method

    request_parameters = {
        "integration.request.path.proxy" = "method.request.path.proxy"
    }

    type = var.input_integration_type
    uri = "http://${var.nlb_dns_address}:${var.app_port}/{proxy}"
    integration_http_method = var.http_integration_method
    connection_type = "VPC_LINK"
    connection_id = aws_api_gateway_vpc_link.admin_tool.id
}

resource "aws_api_gateway_deployment" "admin_tool" {
    rest_api_id = aws_api_gateway_rest_api.admin_tool.id
    stage_name = "${var.environment}-env"

    variables = {
      "resources" = join(", ", [aws_api_gateway_resource.admin_tool.id])
    }
    depends_on = [
      aws_api_gateway_integration.admin_tool
    ]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_api_gateway_vpc_link" "admin_tool" 
  name = "vpc-link-${var.cluster_name}"
  target_arns = [var.nlb_arn]
}