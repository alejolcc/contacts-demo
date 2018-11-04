use Mix.Config

config :contacts, Contacts.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  database: "contacts_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :contacts, garbage_collector_interval: 600_00
