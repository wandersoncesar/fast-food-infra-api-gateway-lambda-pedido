package br.com.fiap.postech;

import java.util.Collection;
import java.util.Map;
import javax.crypto.SecretKey;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;

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

        Map<String, String> headers = input.getHeaders();
        //String authorizationToken = headers.get("Authorization");


        List<String> headersValues = headers.values().stream().toList();
        String authorizationToken = headersValues.get(1);

        System.out.println("list=>>> " + headersValues);
        System.out.println("====================");
        System.out.println("TOKEN=>>> " + authorizationToken);
        System.out.println("====================");
        System.out.println(headers.values());
        System.out.println("====================");

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
//JS - "arn:aws:execute-api:us-east-2:734474252741:7kmwryuvml/dev/GET/teste"


//@Path("/login")
//public class LoginResource {
//
//    String base64Secret = "Y2hhdmUtc2VjcmV0YS1sYW1iZGEtZmFzdC1mb29kLWZpYXAtcG9zdGVjaC10dXJtYS1kZS1hcnF1aXRldHVyYS1kZS1zb2Z0d2FyZQo=";
//    byte[] keyBytes = Decoders.BASE64.decode(base64Secret);
//    private final SecretKey CHAVE = Keys.hmacShaKeyFor(keyBytes);
//
//    @GET
//    @Path("{cpf}")
//    @Produces(MediaType.APPLICATION_JSON)
//    public Response post(@PathParam("cpf") String cpf)
//    {
//        try {
//
//            if ( cpf != null ) {
//                cpf  = cpf.trim();
//
//                String urlParaChamada = "http://viacep.com.br/ws/06050120/json";
//                URL url = new URL(urlParaChamada);
//                HttpURLConnection conexao = (HttpURLConnection) url.openConnection();
//
//                if(conexao.getResponseCode() == 200)
//                {
//                    String jwtToken = Jwts.builder()
//                            .setSubject(cpf)
//                            .setIssuedAt(new Date())
//                            .setExpiration(Date.from(LocalDateTime.now().plusMinutes(15L).atZone(ZoneId.systemDefault()).toInstant()))
//                            .signWith(CHAVE, SignatureAlgorithm.HS512)
//                            .compact();
//
//                    return Response.status(200).entity(jwtToken).build();
//                } else {
//                    return Response.status(401).entity("CPF inválido").build();
//                }
//            } else {
//                return Response.status(400).entity("CPF deve ser informado!").build();
//            }
//        } catch (IOException e) {
//            return Response.status(500).entity(e.getMessage()).build();
//        }
//    }
//}