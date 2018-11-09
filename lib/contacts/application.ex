defmodule Contacts.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Prometheus
    Contacts.WebExporter.setup()
    Contacts.Instrumenter.setup()

    port = Application.get_env(:contacts, :port)

    children = [
      {Contacts.Repo, []},
      Contacts.Tasks,
      Plug.Cowboy.child_spec(scheme: :http, plug: Contacts.Router, options: [port: port])
    ]

    opts = [strategy: :one_for_one, name: Contacts.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
