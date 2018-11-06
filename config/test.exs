use Mix.Config

config :contacts, Contacts.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  database: "contacts_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :logger, compile_time_purge_level: :debug
config :contacts, garbage_collector_interval: 60_000
