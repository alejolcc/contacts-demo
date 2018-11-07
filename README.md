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
GET /contacts        		List contacts of the database 
POST /contacts       		Create a contact   
GET /contacts/:email 		Fetch contact with email
PUT /contacts/:email   		Update a contact with the JSON on the payload
DELETE /contacts/:email    	Delete a contact with email
```
For filter purpouses `GET` /contacts accept query params:
* {field}={value}			  
* _ord = asc | desc
* _sort={field}


Method | URI | Status Code
-------|-----|------------
`GET`|/contacts|`200`
`POST`|/contacts|`200` `400`
`GET`|/contacts/:email|`200` `404`
`PUT`|/contacts/:email|`200` `400` `404`
`DELETE`|/contacts/:email|`204` `404`

## Samples

```bash
curl --header "Content-Type: application/json" --request GET http://localhost:4000/contacts?name=Jhon&_ord=desc&_sort=surname

curl --header "Content-Type: application/json" --request POST --data '{"name":"Jane","surname":"Doe", "phone_number":"+541231231", "email":"Jane@example.com" }' http://localhost:4000/contacts

curl --header "Content-Type: application/json" --request GET http://localhost:4000/contacts/Jane@example.com

curl --header "Content-Type: application/json" --request PUT --data '{"name":"Jane"}' http://localhost:4000/contacts/Jhon@example.com

curl --header "Content-Type: application/json"  --request DELETE   http://localhost:4000/contacts/Jane@example.com

```





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

Docs
----
To more details see the docs on doc/index.html