defmodule Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:email, :string, autogenerate: false}
  schema "contacts" do
    field :name, :string
    field :surname, :string
    field :phone_number, :string
    field :active, :boolean, default: true
  end

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, [:email, :name, :surname, :phone_number, :active])
    |> validate_required([:email, :name, :surname, :active])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

end
  