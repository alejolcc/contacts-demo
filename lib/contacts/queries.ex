defmodule Contacts.Queries do
  import Ecto.Query, warn: true
  alias Contacts.Repo
  alias Contacts.Contact
    
  @spec create_contact(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_contact(attrs) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @spec mark_as_delete(binary()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def mark_as_delete(email) do
    Contact
    |> Repo.get(email)
    case Repo.get(Contact, email) do
      nil -> {:ok, %{}}
      contact -> Contact.changeset(contact, %{active: "false"}) |> Repo.update()
    end
  end

  @spec delete_marked_contacts() :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete_marked_contacts() do
    query = from c in Contact, where: c.active == false
    Repo.delete_all(query)
  end

  @spec update_contact(binary(), map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update_contact(email, attrs) do
    Contact
    |> Repo.get(email)
    |> Contact.changeset(attrs)
    |> Repo.update!()
  end

  @spec list_contact() :: [Ecto.Schema.t()] | no_return()
  def list_contact do
    query = from c in Contact, where: c.active == true
    Repo.all(query)
  end

  @spec get_contact(binary()) :: Ecto.Schema.t() | nil | no_return()
  def get_contact(email) do
    query = from c in Contact, where: c.active == true and c.email == ^email
    Repo.one(query)
  end

end
  