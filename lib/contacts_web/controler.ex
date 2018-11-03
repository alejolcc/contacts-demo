defmodule Contacts.Controler do
  @moduledoc """
  Controller module to interact with backend 
  """
  import Plug.Conn

  alias Contacts.Queries

  def index(conn, params) do
    res = Queries.list_contact()
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "list contacts from controller")
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end
