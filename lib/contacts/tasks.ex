defmodule Contacts.Tasks do
  @moduledoc """
  Module to implement cronn task
  """
  require Logger
  alias Contacts.Utils

  use Task
  alias Contacts.Queries

  def start_link(_arg) do
    Task.start_link(__MODULE__, :clean_db, [])
  end

  @doc """
  Remove contacts marked to delete with a configured interval `garbage_collector_interval`
  """
  def clean_db do
    Utils.debug "Cleaning Database"
    interval = Application.get_env(:contacts, :garbage_collector_interval)

    receive do
    after
      interval ->
        do_clean_db()
        clean_db()
    end
  end

  defp do_clean_db do
    Queries.delete_marked_contacts()
  end
end
