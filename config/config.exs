use Mix.Config

config :contacts, ecto_repos: [Contacts.Repo]
config :contacts, port: 4000

import_config "#{Mix.env()}.exs"
