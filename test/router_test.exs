defmodule Contacts.RouterTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use Plug.Test

  alias Contacts.Contact
  alias Contacts.Repo
  alias Contacts.Router

  @opts Contacts.Router.init([])

  defp create(attrs) do
    %Contact{}
    |>Contact.changeset(attrs)
    |> Repo.insert()
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Contacts.Repo)

    users = [%{name: "John", email: "john@example.com", surname: "Doe", phone_number: "123"},
            %{name: "Jane", email: "jane@example.com", surname: "Doe", phone_number: "123"}]
    [{:ok, user1}, {:ok, user2}] = Enum.map(users, &create(&1))
    {:ok, %{user1: user1, user2: user2}}
  end

  test "index", context do

    conn = conn(:get, "/contacts")
    conn = Router.call(conn, @opts)

    user1 = context.user1
    user2 = context.user2

    expected = [%{"name" => user1.name, "email" => user1.email, "active" => true,
                  "surname" => user1.surname, "phone_number" => user1.phone_number},
                %{"name" => user2.name, "email" => user2.email, "active" => true,
                  "surname" => user2.surname, "phone_number" => user2.phone_number}]

    response = conn.resp_body |> Poison.decode!()

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end

  test "create", context do
    
    attrs = %{name: "Nicolas", surname: "Doe",
              phone_number: "123", email: "nico@example"}
              |> Poison.encode!()

    conn = conn("post", "/contacts", attrs) |> put_req_header("content-type", "application/json")
    conn = Router.call(conn, @opts)

    expected = %{"name" => "Nicolas", "surname" => "Doe", "active" => true,
                 "phone_number" => "123", "email" => "nico@example"}

    response = conn.resp_body |> Poison.decode!()

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response
  
  end

  test "show", context do

    conn = conn(:get, "/contacts/john@example.com")
    conn = Router.call(conn, @opts)

    user1 = context.user1

    expected = %{"name" => user1.name, "email" => user1.email, "active" => true,
                 "surname" => user1.surname, "phone_number" => user1.phone_number}

    response = conn.resp_body |> Poison.decode!()

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end

  test "update", context do

    attrs = %{name: "Nicolas", surname: "Rios",
              phone_number: "123"}
              |> Poison.encode!()

    conn = conn("put", "/contacts/john@example.com", attrs) |> put_req_header("content-type", "application/json")
    conn = Router.call(conn, @opts)

    user1 = context.user1

    expected = %{"name" => "Nicolas", "email" => user1.email, "active" => true,
                  "surname" => "Rios", "phone_number" => user1.phone_number}

    response = conn.resp_body |> Poison.decode!()

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end

  test "delete", context do

    conn = conn(:delete, "/contacts/john@example.com")
    conn = Router.call(conn, @opts)

    user1 = context.user1

    expected = ""

    response = conn.resp_body

    assert conn.state == :sent
    assert conn.status == 204
    assert expected == response

  end

end
