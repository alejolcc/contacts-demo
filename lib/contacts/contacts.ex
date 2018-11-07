defmodule Contacts.Contact do
  @moduledoc """
  Define the schema for the app

  ```
  email: email of the contact (required, primary_key)
  name: name of the contact (required)
  surname: surname of the contact (required)
  phone_number: movil/home phone of the contact
  active: mark the contact to be deleted by the garbage collector (required)
  ```
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

  @doc false
  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:email, :name, :surname, :active])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, name: :contacts_pkey)
  end

end
