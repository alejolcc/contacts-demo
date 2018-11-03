defmodule Contacts.Controler do
  @moduledoc """
  Controller module to interact with backend 
  """
  import Plug.Conn

  alias Contacts.Queries

  # TODO: manage error/nil cases

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t() | no_return()
  def index(conn, params) do
    res = Queries.list_contact()
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(res))
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t() | no_return()
  def create(conn, attrs) do
    case Queries.create_contact(attrs) do
      {:ok, res} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(res))
      {:error, changeset} ->
        handle_error(conn, changeset.errors)
    end
  end

  @spec show(Plug.Conn.t(), binary()) :: Plug.Conn.t() | no_return()
  def show(conn, email) do
    res = Queries.get_contact(email)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(res))
  end

  @spec update(Plug.Conn.t(), binary(), map()) :: Plug.Conn.t() | no_return()
  def update(conn, email, attrs) do
    case Queries.update_contact(email, attrs) do
      {:ok, res} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(res))
      {:error, changeset} ->
        handle_error(conn, changeset.errors)
    end
  end

  @spec delete(Plug.Conn.t(), binary()) :: Plug.Conn.t() | no_return()
  def delete(conn, email) do
    Queries.mark_as_delete(email)
    conn
    |> put_status(:no_content)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(204, "")
  end

  defp handle_error(conn, error) do
    IO.inspect error
    send_resp(conn, 404, "error from controler")
  end

end
