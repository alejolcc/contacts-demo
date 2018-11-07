use Mix.Config

config :contacts, Contacts.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "contacts_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :contacts, cronn_interval: 600_000
