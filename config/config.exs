use Mix.Config

config :contacts, ecto_repos: [Contacts.Repo]
config :contacts, garbage_collector_interval: 600_000

import_config "#{Mix.env()}.exs"
