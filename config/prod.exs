use Mix.Config

config :contacts, Contacts.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "contacts_prod",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :contacts, garbage_collector_interval: 600_000
