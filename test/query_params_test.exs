defmodule Contacts.QueryParamsTest do
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

    users = [
      %{name: "John1", email: "john1@example.com", surname: "Doe4", phone_number: "123"},
      %{name: "John2", email: "john2@example.com", surname: "Doe3", phone_number: "123"},
      %{name: "John3", email: "john3@example.com", surname: "Doe2", phone_number: "123"},
      %{name: "John4", email: "john4@example.com", surname: "Doe1", phone_number: "123"}
    ]
    [{:ok, user1}, {:ok, user2}, {:ok, user3}, {:ok, user4}] = Enum.map(users, &create(&1))
    {:ok, %{user1: user1, user2: user2, user3: user3, user4: user4}}
  end

  test "simple_filters", context do

    conn = conn(:get, "/contacts?surname=Doe4")
    conn = Router.call(conn, @opts)

    user1 = context.user1

    expected = Poison.encode!([user1])
    response = conn.resp_body

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end

  test "simple_ord", context do

    conn = conn(:get, "/contacts?_ord=desc")
    conn = Router.call(conn, @opts)

    user1 = context.user1
    user2 = context.user2
    user3 = context.user3
    user4 = context.user4

    expected = Poison.encode!([user4, user3, user2, user1])
    response = conn.resp_body

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end

  test "simple_sort", context do

    conn = conn(:get, "/contacts?_sort=surname")
    conn = Router.call(conn, @opts)

    user1 = context.user1
    user2 = context.user2
    user3 = context.user3
    user4 = context.user4

    expected = Poison.encode!([user4, user3, user2, user1])
    response = conn.resp_body

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end

  test "filter_with_field_non-existent", context do

    conn = conn(:get, "/contacts?sarasa=algo")
    conn = Router.call(conn, @opts)

    user1 = context.user1
    user2 = context.user2
    user3 = context.user3
    user4 = context.user4

    expected = Poison.encode!([user1, user2, user3, user4])
    response = conn.resp_body

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end

  test "sort_with_field_non-existent", context do

    conn = conn(:get, "/contacts?_sort=sarasa")
    conn = Router.call(conn, @opts)

    user1 = context.user1
    user2 = context.user2
    user3 = context.user3
    user4 = context.user4

    expected = Poison.encode!([user1, user2, user3, user4])
    response = conn.resp_body

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end

  test "ord_with_strange_order", context do

    conn = conn(:get, "/contacts?_ord=zigzag")
    conn = Router.call(conn, @opts)

    user1 = context.user1
    user2 = context.user2
    user3 = context.user3
    user4 = context.user4

    expected = Poison.encode!([user1, user2, user3, user4])
    response = conn.resp_body

    assert conn.state == :sent
    assert conn.status == 200
    assert expected == response

  end
end
