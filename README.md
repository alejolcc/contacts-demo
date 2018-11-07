# Contacts

A sample REST app that implement a CRUD API

## About

This is a demo project for educational purpouses.
Implement an application built over Cowboy server through Plug adapters, and Ecto framework like wrappers around the data store. In this case the data store is a Postgres database.

We use Cowboy because is the defacto and most used HTTP server for Erlang/OTP. It is optimized for low latency and low memory usage, and because it uses Ranch for managing connections, Cowboy can easily be embedded in any other application. 

Plug provides a specification for web application components and adapters for web servers, Cowboy in this case. If we have to change the web server, we can do it with with a minimum of effort just changing the adapter.

Ecto is a simple wrapper for data store, with a minimum configuration we can start to persist data into the data store.

## API

```
GET /contacts?{field_name}={field_value}&_ord={ord}&_sort={field_name}        List contacts of the database 
```
 ###### Sample: _**/contacts?surname=Doe&\_ord=desc&\_sort=email**_

Query Params  |Description
------------  | -------------
field_name | Field to filter by
field_value | Field value to match
ord | asc,desc


##### Response
```json
[
    {
        "surname": "Doe",
        "phone_number": "+54912345678765",
        "name": "Jhon",
        "email": "Jhon@example",
        "active": true
    }
]
```
---

```
POST /contacts                                                                Create a contact   
```
###### _/contacts_
##### Body
```json
{
"name": "Jhon",
"surname": "Doe",
"email": "Jhon@example.com"
}
```
##### Response
```json
{
    "surname": "Doe",
    "phone_number": null,
    "name": "Jhon",
    "email": "Jhon@example.com",
    "active": true
}
```
---



```
GET /contacts/:email                                                          Fetch contact with email
```
###### _**/contacts/Jhon@example.com**_
##### Response
```json
{
    "surname": "Doe",
    "phone_number": null,
    "name": "Jhon",
    "email": "Jhon@example.com",
    "active": true
}
```
---




```
PUT /contacts/:email                                                          Update a contact with the JSON on the payload
```
###### _**/contacts/Jhon@example.com**_
##### Body
```json
{
	"name": "Jane"
}
```
##### Response
```json
{
    "surname": "Doe",
    "phone_number": null,
    "name": "Jane",
    "email": "Jhon@example.com",
    "active": true
}
```
---




```
DELETE /contacts/:email                                                       Delete a contact with email
```
###### _**/contacts/Jhon@example.com**_
---

Run on Docker
----

```sh
docker-compose up -d --build
```

This start the app on port 4000 with a postgres database on port 5566


Run Test
----
```sh
docker-compose up -d postgres #start postgres on docker
mix test
```
