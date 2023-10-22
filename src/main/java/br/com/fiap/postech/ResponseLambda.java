package br.com.fiap.postech;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonPOJOBuilder;

@JsonDeserialize(builder = ResponseLambda.Builder.class)
public class ResponseLambda {

    @JsonProperty("principalId")
    private String principalId;

    @JsonProperty("policyDocument")
    private PolicyDocument policyDocument;

    private ResponseLambda(Builder builder) {
        this.principalId = builder.principalId;
        this.policyDocument = builder.policyDocument;
    }

    public String getPrincipalId() {
        return principalId;
    }

    public PolicyDocument getPolicyDocument() {
        return policyDocument;
    }

    public static Builder builder() {
        return new Builder();
    }

    @JsonPOJOBuilder(withPrefix = "")
    public static final class Builder {
        private String principalId;
        private PolicyDocument policyDocument;

        private Builder() { }

        public Builder principalId(String principalId) {
            this.principalId = principalId;
            return this;
        }

        public Builder policyDocument(PolicyDocument policyDocument) {
            this.policyDocument = policyDocument;
            return this;
        }

        public ResponseLambda build() {
            return new ResponseLambda(this);
        }
    }
}
