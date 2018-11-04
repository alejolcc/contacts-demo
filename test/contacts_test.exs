defmodule Contacts.MyTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Contacts.Contact
  alias Contacts.Queries
  alias Contacts.Repo

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

  test "create_contact", _context do
    contact = %{name: "Nicolas", email: "nico@example", surname: "Doe"}

    assert {:ok, _} = Queries.create_contact(contact)

    res = Repo.get(Contact, "nico@example")
    assert res != nil
  end

  test "create_contact_fail", _context do
    contact = %{email: "nico@example", surname: "Doe", phone_number: "+549111234567"}

    assert {:error, _} = Queries.create_contact(contact)
    res = Repo.get(Contact, "nico@example")
    assert nil == res
  end

  test "mark_as_delete", context do
    user1 = context.user1

    assert {:ok, c} = Queries.mark_as_delete(user1.email)
    assert c.active == false
  end

  test "mark_as_delete_with_non-existent", _context do
    assert nil == Queries.mark_as_delete("bad@email")
  end

  test "delete_marked_contacts", context do
    user1 = context.user1
    contact = Repo.get(Contact, user1.email)

    contact
    |> Contact.changeset(%{active: "false"})
    |> Repo.update()

    Queries.delete_marked_contacts()

    res = Repo.get(Contact, user1.email)
    assert nil == res
  end

  test "update_contact", context do
    user1 = context.user1
    c = Repo.get(Contact, user1.email)
    assert user1.name == c.name

    assert {:ok, _} = Queries.update_contact(user1.email, %{name: "alejo"})

    c1 = Repo.get(Contact, user1.email)
    assert "alejo" == c1.name
  end

  test "list_contact", context do

    user1 = context.user1
    user2 = context.user2

    res = Queries.list_contact()

    assert 2 ==  length res
    [c1, c2] = res

    assert user1.name == c1.name
    assert user2.name == c2.name
  end

  test "get_contact", context do

    user1 = context.user1
    c = Queries.get_contact(user1.email)

    assert user1.name == c.name
  end

end
