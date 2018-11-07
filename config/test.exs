use Mix.Config

config :contacts, Contacts.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  database: "contacts_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5566"

config :logger, compile_time_purge_level: :debug
config :contacts, cronn_interval: 60_000
config :contacts, port: 4001
