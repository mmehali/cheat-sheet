#-----------------------------------------------------
#  Keycloak-configuration.sh
#-----------------------------------------------------
#!/usr/bin/env bash

trap 'exit' ERR

echo ""
echo "========================================================"
echo "==         STARTING KEYCLOAK CONFIGURATION            =="
echo "========================================================"

BASEDIR=$(dirname "$0")
source "$BASEDIR"/keycloak-configuration-helpers.sh

if [ "$KCADM" == "" ]; then
    KCADM=$KEYCLOAK_HOME/bin/kcadm.sh
    echo "Using $KCADM as the admin CLI."
fi

$KCADM config credentials --server http://"$HOST_FOR_KCADM":8080/auth --user "$KEYCLOAK_USER" --password "$KEYCLOAK_PASSWORD" --realm master

source "$BASEDIR"/realms.sh

#--------------------------------------------------------------------------------
#  keycloak-configuration-helper.sh
-----------------------------------------------------------------------------
#!/usr/bin/env bash

# the new realm is also set as enabled
createRealm() {
    # arguments
    REALM_NAME=$1
    #
    EXISTING_REALM=$($KCADM get realms/$REALM_NAME)
    if [ "$EXISTING_REALM" == "" ]; then
        $KCADM create realms -s realm="${REALM_NAME}" -s enabled=true
    fi
}

# the new client is also set as enabled
createClient() {
    # arguments
    REALM_NAME=$1
    CLIENT_ID=$2
    #
    ID=$(getClient $REALM_NAME $CLIENT_ID)
    if [[ "$ID" == "" ]]; then
        $KCADM create clients -r $REALM_NAME -s clientId=$CLIENT_ID -s enabled=true
    fi
    echo $(getClient $REALM_NAME $CLIENT_ID)
}

# get the object id of the client for a given clientId
getClient () {
    # arguments
    REALM_NAME=$1
    CLIENT_ID=$2
    #
    ID=$($KCADM get clients -r $REALM_NAME --fields id,clientId | jq '.[] | select(.clientId==("'$CLIENT_ID'")) | .id')
    echo $(sed -e 's/"//g' <<< $ID)
}

# create a user for the given username if it doesn't exist yet and return the object id
createUser() {
    # arguments
    REALM_NAME=$1
    USER_NAME=$2
    #
    USER_ID=$(getUser $REALM_NAME $USER_NAME)
    if [ "$USER_ID" == "" ]; then
        $KCADM create users -r $REALM_NAME -s username=$USER_NAME -s enabled=true
    fi
    echo $(getUser $REALM_NAME $USER_NAME)
}

# the object id of the user for a given username
getUser() {
    # arguments
    REALM_NAME=$1
    USERNAME=$2
    #
    USER=$($KCADM get users -r $REALM_NAME -q username=$USERNAME | jq '.[] | select(.username==("'$USERNAME'")) | .id' )
    echo $(sed -e 's/"//g' <<< $USER)
}

# create a top level flow for the given alias if it doesn't exist yet and return the object id
createTopLevelFlow() {
    # arguments
    REALM_NAME=$1
    ALIAS=$2
    #
    FLOW_ID=$(getTopLevelFlow "$REALM_NAME" "$ALIAS")
    if [ "$FLOW_ID" == "" ]; then
        $KCADM create authentication/flows -r "$REALM_NAME" -s alias="$ALIAS" -s providerId=basic-flow -s topLevel=true -s builtIn=false
    fi
    echo $(getTopLevelFlow "$REALM_NAME" "$ALIAS")
}

deleteTopLevelFlow() {
    # arguments
    REALM_NAME=$1
    ALIAS=$2
    #
    FLOW_ID=$(getTopLevelFlow "$REALM_NAME" "$ALIAS")
    if [ "$FLOW_ID" != "" ]; then
        $KCADM delete authentication/flows/"$FLOW_ID" -r "$REALM_NAME"
    fi
    echo $(getTopLevelFlow "$REALM_NAME" "$ALIAS")
}

getTopLevelFlow() {
    # arguments
    REALM_NAME=$1
    ALIAS=$2
    #
    ID=$($KCADM get authentication/flows -r "$REALM_NAME" --fields id,alias| jq '.[] | select(.alias==("'$ALIAS'")) | .id')
    echo $(sed -e 's/"//g' <<< $ID)
}

# create a new execution for a given providerId (the providerId is defined by AuthenticatorFactory)
createExecution() {
    # arguments
    REALM_NAME=$1
    FLOW=$2
    PROVIDER=$3
    REQUIREMENT=$4
    #
    EXECUTION_ID=$($KCADM create authentication/flows/"$FLOW"/executions/execution -i -b '{"provider" : "'"$PROVIDER"'"}' -r "$REALM_NAME")
    $KCADM update authentication/flows/"$FLOW"/executions -b '{"id":"'"$EXECUTION_ID"'","requirement":"'"$REQUIREMENT"'"}' -r "$REALM_NAME"
}

# create a new subflow
createSubflow() {
    # arguments
    REALM_NAME=$1
    TOPLEVEL=$2
    PARENT=$3
    ALIAS="$4"
    REQUIREMENT=$5
    #
    FLOW_ID=$($KCADM create authentication/flows/"$PARENT"/executions/flow -i -r "$REALM_NAME" -b '{"alias" : "'"$ALIAS"'" , "type" : "basic-flow"}')
    EXECUTION_ID=$(getFlowExecution "$REALM_NAME" "$TOPLEVEL" "$FLOW_ID")
    $KCADM update authentication/flows/"$TOPLEVEL"/executions -r "$REALM_NAME" -b '{"id":"'"$EXECUTION_ID"'","requirement":"'"$REQUIREMENT"'"}'
    echo "Created new subflow with id '$FLOW_ID', alias '"$ALIAS"'"
}

getFlowExecution() {
    # arguments
    REALM_NAME=$1
    TOPLEVEL=$2
    FLOW_ID=$3
    #
    ID=$($KCADM get authentication/flows/"$TOPLEVEL"/executions -r "$REALM_NAME" --fields id,flowId,alias | jq '.[] | select(.flowId==("'"$FLOW_ID"'")) | .id')
    echo $(sed -e 's/"//g' <<< $ID)
}

registerRequiredAction() {
    #arguments
    REALM_NAME="$1"
    PROVIDER_ID="$2"
    NAME="$3"

    $KCADM delete authentication/required-actions/"$PROVIDER_ID" -r "$REALM_NAME"
    $KCADM create authentication/register-required-action -r "$REALM_NAME" -s providerId="$PROVIDER_ID" -s name="$NAME"
}

# get the id of the identityProvider with the given alias
getIdentityProvider () {
    # arguments
    REALM=$1
    IDP_ALIAS=$2
    #
    ID=$($KCADM get identity-provider/instances -r $REALM --fields alias,internalId | jq '.[] | select(.alias==("'$IDP_ALIAS'")) | .internalId')
    echo $(sed -e 's/"//g' <<< $ID)
}

createIdentityProvider() {
    # arguments
    REALM_NAME=$1
    ALIAS=$2
    NAME=$3
    PROVIDER_ID=$4
    #
    IDENTITY_PROVIDER_ID=$(getIdentityProvider $REALM_NAME $ALIAS)
    if [ "$IDENTITY_PROVIDER_ID" == "" ]; then
        $KCADM create identity-provider/instances -r $REALM_NAME -s alias=$ALIAS -s displayName="$NAME" -s providerId=$PROVIDER_ID
    fi
    echo $(getIdentityProvider $REALM_NAME $ALIAS)
}

deleteIdentityProvider() {
    # arguments
    REALM_NAME=$1
    ALIAS=$2
    #
    IDENTITY_PROVIDER_ID=$(getIdentityProvider $REALM_NAME $ALIAS)
    if [ "$IDENTITY_PROVIDER_ID" != "" ]; then
        $KCADM delete identity-provider/instances/$IDENTITY_PROVIDER_ID -r $REALM_NAME
    fi
}

getIdentityProviderMapper() {
    # arguments
    REALM_NAME=$1
    IDENTITY_PROVIDER_ALIAS=$2
    MAPPER_NAME="${3}"
    #
    ID=$($KCADM get identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers -r $REALM_NAME --fields id,name | jq '.[] | select(.name==("'"${MAPPER_NAME}"'")) | .id')
    echo $(sed -e 's/"//g' <<< $ID)
}

createIdentityProviderMapper() {
    # arguments
    REALM_NAME=$1
    IDENTITY_PROVIDER_ALIAS=$2
    MAPPER_NAME="${3}"
    MAPPER_ID=$4
    #
    IDENTITY_PROVIDER_MAPPER_ID=$(getIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "${MAPPER_NAME}")
    if [ "$IDENTITY_PROVIDER_MAPPER_ID" == "" ]; then
        $KCADM create identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers -r $REALM_NAME -s identityProviderAlias=$IDENTITY_PROVIDER_ALIAS -s name="${MAPPER_NAME}" -s identityProviderMapper=$MAPPER_ID
    fi
    echo $(getIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "${MAPPER_NAME}")
}

getExecution() {
    #arguments
    REALM=$1
    FLOW_ID=$2
    PROVIDER_ID=$3
    #
    EXECUTION_ID=$($KCADM get authentication/flows/$FLOW_ID/executions -r $REALM --fields providerId,id | jq '.[] | select(.providerId==("'$PROVIDER_ID'")) |.id')
    echo $(sed -e 's/"//g' <<< $EXECUTION_ID)
}

createIdentityProviderRedirectorConfig() {
    #arguments
    REALM_NAME=$1
    EXECUTION_ID=$2
    #
}



echo "========================================================"
echo "==            KEYCLOAK CONFIGURATION DONE             =="
echo "========================================================"
echo ""



REALM_NAME='federations'

echo "================================="
echo "setting up realm $REALM_NAME..."
echo "================================="

createRealm $REALM_NAME

# enable the storage of admin events including their representation
$KCADM update events/config -r ${REALM_NAME} -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true

# enable the storage of login events and define the expiration of a stored login event
$KCADM update events/config -r ${REALM_NAME} -s eventsEnabled=true -s eventsExpiration=259200

# define the login event types to be stored
$KCADM update events/config -r ${REALM_NAME} -s 'enabledEventTypes=["CLIENT_DELETE", "CLIENT_DELETE_ERROR", "CLIENT_INFO", "CLIENT_INFO_ERROR", "CLIENT_INITIATED_ACCOUNT_LINKING", "CLIENT_INITIATED_ACCOUNT_LINKING_ERROR", "CLIENT_LOGIN", "CLIENT_LOGIN_ERROR", "CLIENT_REGISTER", "CLIENT_REGISTER_ERROR", "CLIENT_UPDATE", "CLIENT_UPDATE_ERROR", "CODE_TO_TOKEN", "CODE_TO_TOKEN_ERROR", "CUSTOM_REQUIRED_ACTION", "CUSTOM_REQUIRED_ACTION_ERROR", "EXECUTE_ACTIONS", "EXECUTE_ACTIONS_ERROR", "EXECUTE_ACTION_TOKEN", "EXECUTE_ACTION_TOKEN_ERROR", "FEDERATED_IDENTITY_LINK", "FEDERATED_IDENTITY_LINK_ERROR", "GRANT_CONSENT", "GRANT_CONSENT_ERROR", "IDENTITY_PROVIDER_FIRST_LOGIN", "IDENTITY_PROVIDER_FIRST_LOGIN_ERROR", "IDENTITY_PROVIDER_LINK_ACCOUNT", "IDENTITY_PROVIDER_LINK_ACCOUNT_ERROR", "IDENTITY_PROVIDER_LOGIN", "IDENTITY_PROVIDER_LOGIN_ERROR", "IDENTITY_PROVIDER_POST_LOGIN", "IDENTITY_PROVIDER_POST_LOGIN_ERROR", "IDENTITY_PROVIDER_RESPONSE", "IDENTITY_PROVIDER_RESPONSE_ERROR", "IDENTITY_PROVIDER_RETRIEVE_TOKEN", "IDENTITY_PROVIDER_RETRIEVE_TOKEN_ERROR", "IMPERSONATE", "IMPERSONATE_ERROR", "INTROSPECT_TOKEN", "INTROSPECT_TOKEN_ERROR", "INVALID_SIGNATURE", "INVALID_SIGNATURE_ERROR", "LOGIN", "LOGIN_ERROR", "LOGOUT", "LOGOUT_ERROR", "PERMISSION_TOKEN", "PERMISSION_TOKEN_ERROR", "REFRESH_TOKEN", "REFRESH_TOKEN_ERROR", "REGISTER", "REGISTER_ERROR", "REGISTER_NODE", "REGISTER_NODE_ERROR", "REMOVE_FEDERATED_IDENTITY", "REMOVE_FEDERATED_IDENTITY_ERROR", "REMOVE_TOTP", "REMOVE_TOTP_ERROR", "RESET_PASSWORD", "RESET_PASSWORD_ERROR", "RESTART_AUTHENTICATION", "RESTART_AUTHENTICATION_ERROR", "REVOKE_GRANT", "REVOKE_GRANT_ERROR", "SEND_IDENTITY_PROVIDER_LINK", "SEND_IDENTITY_PROVIDER_LINK_ERROR", "SEND_RESET_PASSWORD", "SEND_RESET_PASSWORD_ERROR", "SEND_VERIFY_EMAIL", "SEND_VERIFY_EMAIL_ERROR", "TOKEN_EXCHANGE", "TOKEN_EXCHANGE_ERROR", "UNREGISTER_NODE", "UNREGISTER_NODE_ERROR", "UPDATE_CONSENT", "UPDATE_CONSENT_ERROR", "UPDATE_EMAIL", "UPDATE_EMAIL_ERROR", "UPDATE_PASSWORD", "UPDATE_PASSWORD_ERROR", "UPDATE_PROFILE", "UPDATE_PROFILE_ERROR", "UPDATE_TOTP", "UPDATE_TOTP_ERROR", "USER_INFO_REQUEST", "USER_INFO_REQUEST_ERROR", "VALIDATE_ACCESS_TOKEN", "VALIDATE_ACCESS_TOKEN_ERROR", "VERIFY_EMAIL", "VERIFY_EMAIL_ERROR"]'

#############
# identity providers
# swissid
IDENTITY_PROVIDER_ALIAS='swissid'
createIdentityProvider $REALM_NAME $IDENTITY_PROVIDER_ALIAS "SwissID" oidc

$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS -r $REALM_NAME -s trustEmail=true -s 'config={"clientId": "'$CLIENT_ID_ISSUED_BY_SWISSID'", "clientSecret" : "'CLIENT_SECRET_ISSUED_BY_SWISSID'", "tokenUrl": "https://login.int.swissid.ch:443/idp/oauth2/access_token", "validateSignature": "true", "useJwksUrl": "true", "jwksUrl": "https://login.int.swissid.ch:443/idp/oauth2/connect/jwk_uri", "authorizationUrl": "https://login.int.swissid.ch:443/idp/oauth2/authorize", "clientAuthMethod": "client_secret_post", "syncMode": "FORCE", "defaultScope": "openid profile email address" }'
# mappers
MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "given_name -> firstName" oidc-user-attribute-idp-mapper)
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "given_name",  "user.attribute": "firstName"}'

MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "family_name -> lastName" oidc-user-attribute-idp-mapper)
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "family_name", "user.attribute": "lastName"}'

MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "gender -> gender" oidc-user-attribute-idp-mapper)
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "gender",      "user.attribute": "gender"}'

MAPPER_ID=$(createIdentityProviderMapper $REALM_NAME $IDENTITY_PROVIDER_ALIAS "language -> language" oidc-user-attribute-idp-mapper)
$KCADM update identity-provider/instances/$IDENTITY_PROVIDER_ALIAS/mappers/$MAPPER_ID -r $REALM_NAME -s 'config={"syncMode": "INHERIT", "claim": "language",    "user.attribute": "language"}'

#############
# authentication

# in the `browser` flow the identity provider redirector is set as default (= no login screen should be displayed)
EXECUTION_ID=$(getExecution $REALM_NAME browser identity-provider-redirector)
$KCADM create authentication/executions/$EXECUTION_ID/config -r $REALM_NAME -b '{"config":{"defaultProvider":"'$IDENTITY_PROVIDER_ALIAS'"},"alias":"'$IDENTITY_PROVIDER_ALIAS'"}'
