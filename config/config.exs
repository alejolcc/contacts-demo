use Mix.Config

config :contacts, ecto_repos: [Contacts.Repo]
config :contacts, port: 4000

config :contacts, Contacts.Repo,
loggers: [Contacts.Instrumenter, Ecto.LogEntry]

import_config "#{Mix.env()}.exs"
