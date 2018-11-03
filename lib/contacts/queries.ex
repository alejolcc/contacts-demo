defmodule Contacts.Queries do
  @moduledoc """
  Module to interact with Database through Ecto Repo and Contact schema
  """
  # TODO: Add logs

  import Ecto.Query, warn: true
  alias Contacts.Contact
  alias Contacts.Repo

  @doc """
  Create a Contact given a map `attrs`

  ## Examples
    create_contact(%{name: "John", email: "john@example.com", surname: "Doe", phone_number: "123"})

  """
  @spec create_contact(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_contact(attrs) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Mark the contact with specified `email` to be remove by the garbage collector

  ## Examples
    mark_as_delete("john@example.com")

  """
  @spec mark_as_delete(binary()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def mark_as_delete(email) do
    Contact
    |> Repo.get(email)
    case Repo.get(Contact, email) do
      nil -> {:ok, %{}}
      contact ->
        contact
        |> Contact.changeset(%{active: "false"})
        |> Repo.update()
    end
  end

  # Used by garbage collector task
  @doc false
  @spec delete_marked_contacts() :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete_marked_contacts do
    query = from c in Contact, where: c.active == false
    Repo.delete_all(query)
  end

  @doc """
  Update contact with specified `email` with `attrs` map

  ## Examples
    update_contact("john@example.com", %{name: Cameron})

  """
  @spec update_contact(binary(), map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update_contact(email, attrs) do
    Contact
    |> Repo.get(email)
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Return a list of contacts
  """
  @spec list_contact() :: [Ecto.Schema.t()] | no_return()
  def list_contact do
    query = from c in Contact, where: c.active == true
    Repo.all(query)
  end

  @doc """
  Return the contact specified by `email`
  """
  @spec get_contact(binary()) :: Ecto.Schema.t() | nil | no_return()
  def get_contact(email) do
    query = from c in Contact, where: c.active == true and c.email == ^email
    Repo.one(query)
  end

end
