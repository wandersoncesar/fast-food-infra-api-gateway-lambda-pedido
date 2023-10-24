package br.com.fiap.postech;

import java.util.Map;
import javax.crypto.SecretKey;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
//import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

import java.util.ArrayList;
import java.util.List;

/**
 * Handler for requests to Lambda function.
 */
public class LambdaHandler implements RequestHandler<APIGatewayProxyRequestEvent, ResponseLambda> {

    public ResponseLambda handleRequest(final APIGatewayProxyRequestEvent input, final Context context) {

        String authorizationToken = "";
        Map<String, String> headers = input.getHeaders();

        if (headers.get("Authorization") != null) {
            authorizationToken = headers.get("Authorization");
        } else {
            List<String> headersValues = headers.values().stream().toList();
            authorizationToken = headersValues.get(1);
        }

        //String authorizationToken = headers.get("Authorization");
        //List<String> headersValues = headers.values().stream().toList();
        //String authorizationToken = headersValues.get(1);


        String base64Secret = "Y2hhdmUtc2VjcmV0YS1sYW1iZGEtZmFzdC1mb29kLWZpYXAtcG9zdGVjaC10dXJtYS1kZS1hcnF1aXRldHVyYS1kZS1zb2Z0d2FyZQo=";
        byte[] keyBytes = Decoders.BASE64.decode(base64Secret);
        SecretKey CHAVE = Keys.hmacShaKeyFor(keyBytes);
        Jwts.parserBuilder().setSigningKey(CHAVE).build().parseClaimsJws(authorizationToken);

        String auth = "Deny";
        if (authorizationToken != null) auth = "Allow";

        APIGatewayProxyRequestEvent.ProxyRequestContext proxyContext = input.getRequestContext();
        APIGatewayProxyRequestEvent.RequestIdentity identity = proxyContext.getIdentity();

        String arn = String.format("arn:aws:execute-api:%s:%s:%s/%s/%s/%s",System.getenv("AWS_REGION"), proxyContext.getAccountId(),
                proxyContext.getApiId(), "dev", proxyContext.getHttpMethod(), "users");

        Statement statement = Statement.builder().effect(auth).resource(arn).build();
        List<Statement> listStatements = new ArrayList<>();
        listStatements.add(statement);
        PolicyDocument policyDocument = PolicyDocument.builder().statements(listStatements)
                .build();

        return ResponseLambda.builder().principalId(identity.getAccountId()).policyDocument(policyDocument).build();
    }
}