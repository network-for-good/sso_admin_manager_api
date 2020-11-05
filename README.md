# SsoAdminApi

The SSO admin manager API allows an NFG application (most likely the Identity server) to get a list of users based on email addresses, sso ids or the internal id of the application. Using the internal id, other NFG applications can request to update admin information (name, email address) in another Ruby based NFG Application

It will return information about the user or users using http codes and a json packet.

## List Request

To return a list of users that match a query value, submit a get to:

````
[domain]/[mount_point]/v1/admins?[query string]
````

Where [query string] can be
  email=[an email address], sso_id=[an sso id], or id=[an internal id]

```
[domain]/[mount_point]/v1/admins?email=this@that.com
```

No values will be returned unless a query string is provided

### Response

The response will include on of the following http codes:

#### 500
The system encountered an issue in handling this request. It may be due to an invalid bearer token, a post with no parameters, or some other unrelated server problem. Ensure you are using the correct bearer token, path, and http verb, and include an id and attempt your request again.

#### 200
Indicates that at least one matching user was found. Will return the a list of found users:

````
{ data:
    [
      {
        first_name: first name of the user
        last_name: last name of the user
        email: email address of the user
        status: "active" or "inactive" or "pending"
        roles: a list of roles as assigned by the application
        root_url: The url that a user should be directed to access this application
        org_status: The status of the organization to which this user belongs
      },
      ...
    ],
  meta:
      {
        record_count: number of records returned
      }
}
````

#### 404
No matching user was found


## Update Request

To update a user, other systems should submit a PUT/PATCH to:

````
[domain]/[mount_point]/v1/admins/:id
````

The :id must be the internal identifier for the resource

To obtain the id, first request a list of users using the list end point and passing the appropriate query

The PUT/PATCH must include a JSON packet with the information to be updated. It can include email, first_name, last_name:

````
{ email: "email.example.com", last_name: "Smith"}
````

### Response

The response will include one of the following http codes:

#### 500
The system encountered an issue in handling this request. It may be due to an invalid bearer token, a post with no parameters, or some other unrelated server problem. Ensure you are using the correct bearer token, path, and http verb, and include an id and attempt your request again.

#### 200
Indicates that a matching user was updated. Will return the user's update information:

````
{
  first_name: first name of the user
  last_name: last name of the user
  email: email address of the user
  status: "active" or "inactive" or "pending"
  roles: a list of roles as assigned by the application
  root_url: The url that a user should be directed to access this application
  org_status: The status of the organization to which this user belongs
}
````

#### 404
No matching user was found

## Requirements of containing app
There are several expectations that this library has for the containing application.
1. The target user class is Admin, which must have the following attributes and/or methods:
  * id,
  * first_name,
  * last_name,
  * email,
  * status,
  * roles - A list of allowed roles
  * root_url - A url corresponding to the site the admin belongs to
  * org_status - The status of the organization to which this user belongs
2. Admin should have both of the following scopes
3. The Admin class can have an sso_id field that stores an ID provided by the SSO server and can be used to identify the user. This library will check for the existence of this field.

## Domains
The domains are as follows:

* QA: api.sso-qa.givecorps.com
* Beta: api.networkforgood-beta.com
* Production: api.networkforgood.com

## Authentication
The request must include an Authorization header with a Bearer token that is appropriate for the environment.
