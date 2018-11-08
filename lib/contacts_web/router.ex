defmodule Contacts.Router do
  @moduledoc false
  
  use Plug.Router

  alias Contacts.Controler

  plug Contacts.WebExporter
  plug :match
  plug Plug.Parsers,  parsers: [:json],
                      pass:  ["application/json"],
                      json_decoder: Poison
  plug :dispatch
  

  get "/contacts" do
    Controler.index(conn, conn.params)
  end

  post "/contacts" do
    Controler.create(conn, conn.body_params)
  end

  get "/contacts/:email" do
    Controler.show(conn, email)
  end

  put "/contacts/:email" do
    Controler.update(conn, email, conn.body_params)
  end

  delete "/contacts/:email" do
    Controler.delete(conn, email)
  end

  match "/contacts" do
    send_resp(conn, 405, "")
  end
end
