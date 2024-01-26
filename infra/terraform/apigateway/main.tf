resource "aws_api_gateway_rest_api" "api_fast_food" {
  name        = "API Gateway fast-food - cliente"
  description = "API Gateway para API REST fast-food"
}

resource "aws_api_gateway_resource" "api_fast_food" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_rest_api.api_fast_food.root_resource_id
  path_part   = "api_fast_food"
}

resource "aws_api_gateway_method" "root_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_fast_food.id
  resource_id   = aws_api_gateway_resource.api_fast_food.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.api_fast_food.id
  http_method             = aws_api_gateway_method.root_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://cliente-alb-fast-food-app-645897645.us-east-1.elb.amazonaws.com"
}

resource "aws_api_gateway_deployment" "api_fast_food_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  stage_name  = "dev"
}

resource "aws_api_gateway_stage" "dev" {
  stage_name    = "dev"
  deployment_id = aws_api_gateway_deployment.api_fast_food_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_fast_food.id
}

# /cliente

resource "aws_api_gateway_resource" "cliente" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.api_fast_food.id
  path_part   = "cliente"
}

resource "aws_api_gateway_method" "cadastrar_cliente" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.cliente.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cadastrar_cliente" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.cliente.id
  http_method             = aws_api_gateway_method.cadastrar_cliente.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://cliente-alb-fast-food-app-645897645.us-east-1.elb.amazonaws.com"
}

# /cliente?cpf=55568254970

resource "aws_api_gateway_method" "busca_cliente" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.cliente.id
  http_method = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
  request_parameters = {
    "method.request.querystring.cpf" = true
  }
}

resource "aws_api_gateway_integration" "busca_cliente" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.cliente.id
  http_method             = aws_api_gateway_method.busca_cliente.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://cliente-alb-fast-food-app-645897645.us-east-1.elb.amazonaws.com"
}

# /autenticar?cpf=55568254970

resource "aws_api_gateway_resource" "autenticar" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.api_fast_food.id
  path_part   = "autenticar"
}

resource "aws_api_gateway_method" "autenticar_cliente" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.autenticar.id
  http_method = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.cpf" = true
  }
}

resource "aws_api_gateway_integration" "autenticar_cliente" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.autenticar.id
  http_method             = aws_api_gateway_method.autenticar_cliente.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://cliente-alb-fast-food-app-645897645.us-east-1.elb.amazonaws.com"
}

resource "aws_api_gateway_authorizer" "custom" {
  name                   = "custom-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.api_fast_food.id
  authorizer_uri         = var.lambda_authorizadora_invokearn
  type                             = "REQUEST"
  identity_source                  = "method.request.header.Authorization"
  authorizer_result_ttl_in_seconds = 0
}
