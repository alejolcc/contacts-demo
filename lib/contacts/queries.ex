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
  @spec mark_as_delete(binary()) :: {:ok, Ecto.Schema.t()} | nil | {:error, Ecto.Changeset.t()}
  def mark_as_delete(email) do
    case Repo.get(Contact, email) do
      nil -> 
        nil
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
  @spec update_contact(binary(), map()) :: {:ok, Ecto.Schema.t()} | nil | {:error, Ecto.Changeset.t()}
  def update_contact(email, attrs) do
    case Repo.get(Contact, email) do
      nil ->
        nil
      contact ->
        contact
        |> Contact.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Return a list of contacts
  Accept params for filter and sort

  ## Params
    {field name}: filter the search by field value
    _ord: allow to order by asc or desc, default: asc
    _sort: allow especifie a field to sort by, default: `email`

  ## Example
    list_contact(%{"_ord" => "desc", "_sort" => "name", "surname" => "Doe"})
  """

  @spec list_contact(map()) :: [Ecto.Schema.t()] | no_return()
  def list_contact(params) do
    filters = get_filters(params) ++ [active: true]
    order_key = get_order_key(params)

    query = case get_order(params) do
      :desc-> from(c in Contact, where: ^filters, order_by: [desc: ^order_key])
      _ ->    from(c in Contact, where: ^filters, order_by: [asc: ^order_key])
    end

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

  ######################
  # Private Functions
  ######################

  # Return the query filter expresion form query params
  # If field doesnt exist ignore the filter
  defp get_filters(params) do
    params
    |> Enum.filter(fn {x, _} -> !String.starts_with?(x, "_") and is_field?(x) end)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
  end

  # Return the query expresion for sort asc or desc depends of query param _ord
  # If ord value incorrect does nothing
  defp get_order(params) do
    params
    |> Map.get("_ord", "asc")
    |>String.to_atom
  end

  # Return the query to order_by value especified with _sort
  # If value is not a field return the query expresion to order_by `email`
  defp get_order_key(params) do
    value = Map.get(params, "_sort", "email")
    case is_field?(value) do
      true -> String.to_atom(value)
      _ -> :email
    end
  end

  # Check if a value is a field of Contact schema
  defp is_field?(value) do
    fields = Contact.__schema__(:fields)
    String.to_atom(value) in fields
  end
end
