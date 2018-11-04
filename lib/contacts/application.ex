defmodule Contacts.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Contacts.Repo, []},
      Contacts.Tasks,
      Plug.Cowboy.child_spec(scheme: :http, plug: Contacts.Router, options: [port: 4001])
    ]

    opts = [strategy: :one_for_one, name: Contacts.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
