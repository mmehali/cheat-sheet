#!/usr/bin/env bash

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
