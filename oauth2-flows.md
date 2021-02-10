### 1) Authorization Code Flow
#### 1.1. Request ToAuthorization Endpoint
```
GET {Authorization Endpoint}
  ?response_type=code             // - Required
  &client_id={Client ID}          // - Required
  &redirect_uri={Redirect URI}    // - Conditionally required
  &scope={Scopes}                 // - Optional
  &state={Arbitrary String}       // - Recommended
  &code_challenge={Challenge}     // - Optional
  &code_challenge_method={Method} // - Optional
  HTTP/1.1
HOST: {Authorization Server}
```

Note: The snippet above contains request parameters from RFC 7636 in addition to ones from RFC 6749. 
See PKCE Authorization Request for details.

#### 1.2. Response From Authorization Endpoint
```
HTTP/1.1 302 Found
Location: {Redirect URI}
  ?code={Authorization Code}  // - Always included
  &state={Arbitrary String}   // - Included if the authorization
                            //   request included 'state'.
```

#### 1.3. Request To Token Endpoint
```
POST {Token Endpoint} HTTP/1.1
Host: {Authorization Server}
Content-Type: application/x-www-form-urlencodedgrant_type=authorization_code  // - Required
&code={Authorization Code}     // - Required
&redirect_uri={Redirect URI}   // - Required if the authorization
                               //   request included 'redirect_uri'.
&code_verifier={Verifier}      // - Required if the authorization
                               //   request included
                               //   'code_challenge'.
```


Note: The snippet above contains request parameters from RFC 7636 in addition to ones from RFC 6749.
See PKCE Token Request for details.

If the client type of the client application is “public”, the client_id request parameter is additionally required. 
On the other hand, if the client type is “confidential”, depending on the client authentication method, an 
Authorization HTTP header, a pair of client_id & client_secret parameters, or some other input parameters are 
required. See “OAuth 2.0 Client Authentication” for details.

#### 1.4. Response From Token Endpoint
```
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
Cache-Control: no-store
Pragma: no-cache{
  "access_token": "{Access Token}",    // - Always included
  "token_type": "{Token Type}",        // - Always included
  "expires_in": {Lifetime In Seconds}, // - Optional
  "refresh_token": "{Refresh Token}",  // - Optional
  "scope": "{Scopes}"                  // - Mandatory if the granted
                                       //   scopes differ from the
                                       //   requested ones.
}
```
