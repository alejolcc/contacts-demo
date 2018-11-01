defmodule Contacts.Repo.Migrations.Contacts do
  use Ecto.Migration

  def change do
    create table(:contacts, primary_key: false) do
      add :email, :string, null: false, primary_key: true
      add :name, :string, null: false
      add :surname, :string, null: false
      add :phone_number, :string
      add :active, :boolean, null: false
    end
  end
end
