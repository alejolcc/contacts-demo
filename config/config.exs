use Mix.Config

config :contacts, ecto_repos: [Contacts.Repo]

import_config "#{Mix.env()}.exs"
