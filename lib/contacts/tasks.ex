defmodule Contacts.Tasks do
  @moduledoc """
  Module to implement cronn task

  To implement a new cronn task, call the function with expected behaviour inside of `exec_cron_task/0`
  """
  require Logger
  alias Contacts.Utils

  use Task
  alias Contacts.Queries

  def start_link(_arg) do
    Task.start_link(__MODULE__, :exec_cron_tasks, [])
  end

  @doc """
  Execute tasks every `cronn_interval` param.
  The interval can be configured in config/config.exs
  """
  def exec_cron_tasks do

    interval = Application.get_env(:contacts, :cronn_interval)
    receive do
    after
      interval ->
        do_clean_db()
        exec_cron_tasks()
    end
  end

  defp do_clean_db do
    Utils.debug "Cleaning Database"
    Queries.delete_marked_contacts()
  end
end
