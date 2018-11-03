defmodule Contacts.Tasks do
  use Task
  alias Contacts.Queries

  def start_link(_arg) do
      Task.start_link(__MODULE__, :clean_db, [])
  end

  def clean_db do
      IO.puts "Cleaning Db"
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
  