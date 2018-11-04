defmodule Contacts.Contact do
  @moduledoc """
  Schema for Contact Repo

  email: Email of the contact (required, primary_key)\n
  name: Name of the contact (required)\n
  surname: Surname of the contact (required)\n
  phone_number: Movil/Home phone of the contact\n
  active: Mark the contact to be deleted by the garbage collector (required)
  
  """

  use Ecto.Schema
  import Ecto.Changeset

  @fields [:name, :email, :surname, :phone_number, :active]

  @primary_key {:email, :string, autogenerate: false}
  @derive {Poison.Encoder, only: @fields}
  schema "contacts" do
    field :name, :string
    field :surname, :string
    field :phone_number, :string
    field :active, :boolean, default: true
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:email, :name, :surname, :active])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, name: :contacts_pkey)
  end

end
