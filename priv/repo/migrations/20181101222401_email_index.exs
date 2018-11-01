defmodule Contacts.Repo.Migrations.EmailIndex do
  use Ecto.Migration

  def change do
    create unique_index(:contacts, [:email])
  end

  
end
