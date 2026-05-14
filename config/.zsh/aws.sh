rpms_env() {
    export DB_HOST="localhost"
    export DB_PORT="5433"
    export DB_NAME="research_publications"
    export DB_SECRET_ARN="arn:aws:secretsmanager:us-east-1:100878379096:secret:DatabaseCredentialsSecret74-PA1Lz2QqnNGZ-LreJ4d"
    export RAW_RESPONSES_BUCKET_NAME="dev-s3stack-rawresponsesbucketa1bc207d-y4vmpto6h895"
    export SECRETS_ARN="arn:aws:secretsmanager:us-east-1:100878379096:secret:research-publication-system/application-config-2x14l1"
}

cic_acc() {
    export AWS_PROFILE=cic
    export AWS_DEFAULT_ACCOUNT=$(aws sts get-caller-identity --profile cic --query Account --output text)
    export AWS_DEFAULT_REGION=us-east-1
    rpms_env
}

aws_get_secret() {
    aws secretsmanager get-secret-value --secret-id $1 --query SecretString --output text | jq
}
arn_to_env() {
    local prefix="$1"
    local arn="$2"

    RESULT=$(aws secretsmanager get-secret-value \
        --secret-id "$arn" \
        --query SecretString \
        --output text |
        jq -r --arg prefix "$prefix" '
        to_entries[]
        | "export \(
            if $prefix == "" then .key else ($prefix + .key) end
          )=\(.value | tostring | @sh)"
          ')
    eval "$RESULT"
    echo "GOOD! env variables set from $arn with prefix '$prefix'"
}
