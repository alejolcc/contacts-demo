defmodule Contacts.Router do
  use Plug.Router

  # TODO: add logs

  plug :match
  plug :dispatch

  get "/contacts" do
    send_resp(conn, 200, "list contacts")
  end

  post "/contacts" do
    send_resp(conn, 200, "create a contact")
  end

  get "/contacts/:email" do
    send_resp(conn, 200, "get a contact")
  end

  put "/contacts/:email" do
    send_resp(conn, 200, "update a contact")
  end

  delete "/contacts/:email" do
    send_resp(conn, 200, "mark to delete a contact")
  end

  # forward "/users", to: UsersRouter

  # TODO: Search for a correct manage for an error
  match _ do
    send_resp(conn, 404, "error not found")
  end
end
