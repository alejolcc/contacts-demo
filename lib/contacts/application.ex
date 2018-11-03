defmodule Contacts.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Contacts.Repo, []},
      Contacts.Tasks,
    ]

    opts = [strategy: :one_for_one, name: Contacts.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
