# Variables
VAULT_CONTAINER_NAME="vault"
VAULT_ADDR="http://127.0.0.1:8200"
VAULT_ROOT_TOKEN="YOUR ROOT TOKEN HERE"
SCRIPT_DIR=$(pwd)
POLICIES_DIR="$SCRIPT_DIR/policies"
NEW_TOKENS_DIR="$SCRIPT_DIR/tokens"

PRIVATE_KEY='YOUR PRIVATE KEY HERE'
PUBLIC_KEY='YOUR PUBLIC KEY HERE'

# Check jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq could not be found, please install it to proceed."
    exit 1
fi

mkdir -p $NEW_TOKENS_DIR

create_secret_engine() {
    local engine_path=$1
    echo "Enabling secret engine at path $engine_path..."
    docker exec $VAULT_CONTAINER_NAME /bin/sh -c "export VAULT_ADDR=$VAULT_ADDR && export VAULT_TOKEN=$VAULT_ROOT_TOKEN && vault secrets enable -path=$engine_path kv" || echo "Secret engine at path $engine_path already exists"
}

create_secret() {
    local engine_path=$1
    local secret_name=$2
    local secret_value=$3
    echo "Creating secret $secret_name in $engine_path..."
    docker exec $VAULT_CONTAINER_NAME /bin/sh -c "export VAULT_ADDR=$VAULT_ADDR && export VAULT_TOKEN=$VAULT_ROOT_TOKEN && vault kv put $engine_path/$secret_name key=\"$secret_value\""
}

apply_policy() {
    local policy_file=$1
    local policy_name=$(basename $policy_file .hcl)
    echo "Applying policy $policy_name from file $policy_file..."
    docker exec $VAULT_CONTAINER_NAME mkdir -p /mnt/data
    docker cp $policy_file $VAULT_CONTAINER_NAME:/mnt/data/$(basename $policy_file)
    docker exec $VAULT_CONTAINER_NAME /bin/sh -c "export VAULT_ADDR=$VAULT_ADDR && export VAULT_TOKEN=$VAULT_ROOT_TOKEN && vault policy write $policy_name /mnt/data/$(basename $policy_file)"
    docker exec $VAULT_CONTAINER_NAME rm /mnt/data/$(basename $policy_file)
}

create_token() {
    local policy_name=$1
    local token_file=$2
    echo "Creating token for policy $policy_name with endless TTL..."
    NEW_TOKEN=$(docker exec $VAULT_CONTAINER_NAME /bin/sh -c "export VAULT_ADDR=$VAULT_ADDR && export VAULT_TOKEN=$VAULT_ROOT_TOKEN && vault token create -policy=$policy_name -period=0 -format=json" | jq -r '.auth.client_token')
    echo $NEW_TOKEN > $token_file
}

# Create secret engines
create_secret_engine "private_key"
create_secret_engine "public_keys"

# Create secrets
create_secret "private_key" "test" "$PRIVATE_KEY"
create_secret "public_keys" "test" "$PUBLIC_KEY"

# Apply policies
for policy_file in $POLICIES_DIR/*.hcl; do
    apply_policy $policy_file
done

# Create tokens for each policy and save them
for policy_file in $POLICIES_DIR/*.hcl; do
    policy_name=$(basename $policy_file .hcl)
    create_token $policy_name "$NEW_TOKENS_DIR/$policy_name.token"
done

echo "All tasks completed. Tokens saved in $NEW_TOKENS_DIR."