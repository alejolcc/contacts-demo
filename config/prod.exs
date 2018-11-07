use Mix.Config

config :contacts, Contacts.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "contacts_prod",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5566"

config :contacts, cronn_interval: 600_000
