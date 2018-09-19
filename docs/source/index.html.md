---
title: API Reference

toc_footers:
  - Do stuff


search: true
---

# Seller Signup/Management flow

## `POST /auth`

```shell
curl "http://example.com/auth"
  -X POST
  -H "Content-Type: application/json"
  -d '{"email": "test@example.com", "password": "11112222", "password_confirmation": "11112222"}'
```
### Seller SignUp
New user gets signed-up along with new account. User becomes account admin right-away.

**_Headers:_**

Key | Value | Description
--------- | ------- | -----------
Content-Type | application/json | -

**_Body:_**

Parameter | Required | Description
--------- | ------- | -----------
email | true | User email.
password | true | Valid password.
password_confirmation | true | Password confirmation.

**_Response:_**

<aside class="success">
  200 | (Created)
</aside>

<aside class="warning">
  422 | Email can't be blank / Password can't be blank
</aside>


## `POST /auth/sign_in`

```shell
curl "http://example.com/auth/sign_in"
  -X POST
  -H "Content-Type: application/json"
  -d '{"email": "test@example.com", "password": "11112222"}'
```
### Seller LogIn
Confirmed user can log-in using valid credentials.

**_Headers:_**

Key | Value | Description
--------- | ------- | -----------
Content-Type | application/json | -

**_Body:_**

Parameter | Required | Description
--------- | ------- | -----------
email | true | User email.
password | true | Valid password.


**_Response:_**

<aside class="success">
  200 | Returns `access-token`, `client`, `expiry`, `token-type`, `uid` headers which should be used in further on requests
</aside>

<aside class="warning">
  401 | Invalid login credentials. Please try again.
</aside>


## `DELETE /auth/sign_out`

```shell
curl "http://example.com/auth/sign_out"
  -X DELETE
  -H "access-token: S3SDFF4gdF"
     "client: 32423382103"
     "token-type: Bearer"
     "expiry: 1536421"
     "uid: test@example.com"

```
### Seller LogOut
Logged-in user can log-out using valid credentials.

**_Headers:_**

Key | Value | Description
--------- | ------- | -----------
access-token | S3SDFF4gdF | -
client | 32423382103 | -
token-type | Bearer | -
expiry | 1536421 | -
uid | test@example.com | -

**_Response:_**

<aside class="success">
  200 | Nullifies headers credentials (access-token etc.)
</aside>

<aside class="warning">
  401 | Invalid login credentials. Please try again.
</aside>


## `POST /api/v1/sellers/invite`

```shell
curl "http://example.com/api/v1/sellers/invite"
  -X POST
  -H "access-token: S3SDFF4gdF"
     "client: 32423382103"
     "token-type: Bearer"
     "expiry: 1536421"
     "uid: test@example.com"
  -d '{"email": "badboy@example.com", "name": "BadBoy"}'
```
### User invitation
Confirmed admin user can invite a user within account.

> Succesfull JSON body:

```json
{
  "id": 2,
  "provider": "email",
  "uid": "badboy@example.com",
  "allow_password_change": false,
  "name": "BadBoy",
  "nickname": null,
  "image": null,
  "email": "badboy@example.com",
  "account_id": 1,
  "created_at": "2018-09-18T10:53:01.340Z",
  "updated_at": "2018-09-18T10:53:01.340Z"
}
```

**_Headers:_**

Key | Value | Description
--------- | ------- | -----------
access-token | S3SDFF4gdF | -
client | 32423382103 | -
token-type | Bearer | -
expiry | 1536421 | -
uid | test@example.com | -

**_Body:_**

Parameter | Required | Description
--------- | ------- | -----------
email | true | User email.
name | false | Invited seller name.


**_Response:_**

<aside class="success">
  200 
</aside>

<aside class="warning">
  401 | Invalid login credentials. Please try again.
</aside>

<aside class="warning">
  422 | Email not valid
</aside>

<aside class="warning">
  422 | Email in use
</aside>


## `POST /api/v1/sellers/accept`

```shell
curl "http://example.com/api/v1/sellers/accept"
  -X POST
  -d '{"password": "11112222", "password_confirmation": "11112222", "invitation_token": "token"}'
```
### Accept invitation
User can accept invitation following link in email and sending request including token & password.

> Succesfull JSON body:

```json
{
  "id": 2,
  "provider": "email",
  "uid": "badboy@example.com",
  "allow_password_change": false,
  "name": "BadBoy",
  "nickname": null,
  "image": null,
  "email": "badboy@example.com",
  "account_id": 1,
  "created_at": "2018-09-18T10:53:01.340Z",
  "updated_at": "2018-09-18T10:53:01.340Z"
}
```

**_Body:_**

Parameter | Required | Description
--------- | ------- | -----------
password | true | -
password_confirmation | true | -
invitation_token | true | -

**_Response:_**

<aside class="success">
  200 
</aside>

<aside class="warning">
  401 | Invalid login credentials. Please try again.
</aside>

<aside class="warning">
  406 | Invalid token
</aside>
