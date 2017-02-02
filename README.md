# SsoAuthenticationApi

The SSO admin manager API allows an NFG application (most likely the Identity server) to update admin information (name, email address) in another Ruby based NFG Application

It offers a single interface, and returns information about the user using http codes and a json packet.

It can receive as an admin identifier the admins email address, id, or sso id.

## Request

To update a user, other systems should submit a put/patch to:

````
[domain]/api/v1/admins/:id
````

The domains are as follows:

* QA: api.sso-qa.givecorps.com
* Beta: api.networkforgood-beta.com
* Production: api.networkforgood.com

The post must include a JSON packet with the information to be updated. It can include email, first_name, last_name:

````
{ email: "email.example.com", last_name: "Smith"}
````

The request must also include an Authorization header with a Bearer token that is appopriate for the environment.

## Response

The response will include on of the following http codes

### 500
There system encountered an issue in handling this request. It may be due to an invalid bearer token, a post with no parameters, or some other unrelated server problem. Ensure you are using the correct bearer token and attempt your request again.

### 200
Indicatees the user was successfully updated. May update multiple accounts

````
{
  first_name: first name of the user
  last_name: last name of the user
  email: email address of the user
}
````

### 404
No matching user was found




