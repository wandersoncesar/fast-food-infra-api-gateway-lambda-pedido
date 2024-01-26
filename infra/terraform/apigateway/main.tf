resource "aws_api_gateway_rest_api" "api_fast_food" {
  name        = "API Gateway fast-food"
  description = "API Gateway para API REST fast-food"
}

# /pedidos/checkout

resource "aws_api_gateway_resource" "pedidos" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_rest_api.api_fast_food.root_resource_id
  path_part   = "pedidos"
}

resource "aws_api_gateway_resource" "checkout" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.pedidos.id
  path_part   = "checkout"
}

resource "aws_api_gateway_method" "checkout" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.checkout.id
  http_method = "POST"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
}

resource "aws_api_gateway_integration" "checkout" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.checkout.id
  http_method             = aws_api_gateway_method.checkout.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://fast-food-alb-fast-food-app-779490064.us-east-1.elb.amazonaws.com"
}

#/pedidos

resource "aws_api_gateway_method" "pedidos" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.pedidos.id
  http_method = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
}

resource "aws_api_gateway_integration" "pedidos" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.pedidos.id
  http_method             = aws_api_gateway_method.pedidos.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://fast-food-alb-fast-food-app-779490064.us-east-1.elb.amazonaws.com"
}

#/pedidos/{id}

resource "aws_api_gateway_resource" "pedidos_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.pedidos.id
  path_part   = "{id+}"
}

resource "aws_api_gateway_method" "pedidos_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.pedidos_id.id
  http_method = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
}

resource "aws_api_gateway_integration" "pedidos_id" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.pedidos_id.id
  http_method             = aws_api_gateway_method.pedidos_id.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://fast-food-alb-fast-food-app-779490064.us-east-1.elb.amazonaws.com"
}

# /pedidos/status/{id}

resource "aws_api_gateway_resource" "status" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.pedidos.id
  path_part   = "status"
}

resource "aws_api_gateway_resource" "status_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.status.id
  path_part   = "{id+}"
}

resource "aws_api_gateway_method" "status_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.status_id.id
  http_method = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
}

resource "aws_api_gateway_integration" "status_id" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.status_id.id
  http_method             = aws_api_gateway_method.status_id.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://fast-food-alb-fast-food-app-779490064.us-east-1.elb.amazonaws.com"
}

# pedidos/mudar-status/preparacao/{id}

resource "aws_api_gateway_resource" "mudar_status" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.pedidos.id
  path_part   = "mudar-status"
}

resource "aws_api_gateway_resource" "preparacao" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.mudar_status.id
  path_part   = "preparacao"
}

resource "aws_api_gateway_resource" "preparacao_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.preparacao.id
  path_part   = "{id+}"
}

resource "aws_api_gateway_method" "preparacao_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.preparacao_id.id
  http_method = "PUT"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
}

resource "aws_api_gateway_integration" "preparacao_id" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.preparacao_id.id
  http_method             = aws_api_gateway_method.preparacao_id.http_method
  integration_http_method = "PUT"
  type                    = "HTTP_PROXY"
  uri                     = "http://fast-food-alb-fast-food-app-779490064.us-east-1.elb.amazonaws.com"
}

# pedidos/mudar-status/pronto/{id}

resource "aws_api_gateway_resource" "pronto" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.mudar_status.id
  path_part   = "pronto"
}

resource "aws_api_gateway_resource" "pronto_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.pronto.id
  path_part   = "{id+}"
}

resource "aws_api_gateway_method" "pronto_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.pronto_id.id
  http_method = "PUT"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
}

resource "aws_api_gateway_integration" "pronto_id" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.pronto_id.id
  http_method             = aws_api_gateway_method.pronto_id.http_method
  integration_http_method = "PUT"
  type                    = "HTTP_PROXY"
  uri                     = "http://fast-food-alb-fast-food-app-779490064.us-east-1.elb.amazonaws.com"
}

# pedidos/mudar-status/confirmar-entrega/{id}

resource "aws_api_gateway_resource" "confirmar_entrega" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.mudar_status.id
  path_part   = "confirmar-entrega"
}

resource "aws_api_gateway_resource" "confirmar_entrega_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  parent_id   = aws_api_gateway_resource.confirmar_entrega.id
  path_part   = "{id+}"
}

resource "aws_api_gateway_method" "confirmar_entrega_id" {
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  resource_id = aws_api_gateway_resource.confirmar_entrega_id.id
  http_method = "PUT"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
}

resource "aws_api_gateway_integration" "confirmar_entrega_id" {
  rest_api_id             = aws_api_gateway_rest_api.api_fast_food.id
  resource_id             = aws_api_gateway_resource.confirmar_entrega_id.id
  http_method             = aws_api_gateway_method.confirmar_entrega_id.http_method
  integration_http_method = "PUT"
  type                    = "HTTP_PROXY"
  uri                     = "http://fast-food-alb-fast-food-app-779490064.us-east-1.elb.amazonaws.com"
}

resource "aws_api_gateway_deployment" "api_fast_food_deployment" {
  depends_on = [
    aws_api_gateway_method.checkouts_id,
    aws_api_gateway_integration.checkouts_id,

    aws_api_gateway_method.checkout,
    aws_api_gateway_integration.checkout,

    aws_api_gateway_method.pedidos,
    aws_api_gateway_integration.pedidos,

    aws_api_gateway_method.pedidos_id,
    aws_api_gateway_integration.pedidos_id,

    aws_api_gateway_method.status_id,
    aws_api_gateway_integration.status_id,

    aws_api_gateway_method.preparacao_id,
    aws_api_gateway_integration.preparacao_id,

    aws_api_gateway_method.pronto_id,
    aws_api_gateway_integration.pronto_id,

    aws_api_gateway_method.confirmar_entrega_id,
    aws_api_gateway_integration.confirmar_entrega_id,
    ]
  rest_api_id = aws_api_gateway_rest_api.api_fast_food.id
  stage_name = "dev"
}

resource "aws_api_gateway_authorizer" "custom" {
  name                   = "custom-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.api_fast_food.id
  authorizer_uri         = var.lambda_authorizadora_invokearn
  type                             = "REQUEST"
  identity_source                  = "method.request.header.Authorization"
  authorizer_result_ttl_in_seconds = 0
}
