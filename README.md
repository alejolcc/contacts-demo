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
_**/contacts?surname=Doe&\_ord=desc&\_sort=email**_

Query Params  |Description
------------  | -------------
field_name | Field to filter by
field_value | Field value to match
ord | asc,desc


Return a JSON with a list of user filtered by {field_value} sorted by {field_name} value in {ord} order


```
POST /contacts                                Create a contact   
```
_**/contacts**_




```
GET /contacts/:email                          Fetch contact with email
```
_**/contacts/Jhon@example.com**_




```
PUT /contacts/:email                          Update a contact with the JSON on the payload
```
_**/contacts/Jhon@example.com**_




```
DELETE /contacts/:email                       Delete a contact with email
```
_**/contacts/Jhon@example.com**_

