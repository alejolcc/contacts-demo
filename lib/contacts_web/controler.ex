defmodule Contacts.Controler do
  @moduledoc """
  Controller module to interact with backend 
  """
  import Plug.Conn

  alias Contacts.Queries

  # TODO: add logs

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t() | no_return()
  def index(conn, params) do
    res = Queries.list_contact()
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(res))
  end

  # 400 bad request
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t() | no_return()
  def create(conn, attrs) do
    case Queries.create_contact(attrs) do
      {:ok, res} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(res))
      {:error, changeset} ->
        handle_error(conn, 400, changeset.errors)
    end
  end

  # 404 not found
  @spec show(Plug.Conn.t(), binary()) :: Plug.Conn.t() | no_return()
  def show(conn, email) do
    case Queries.get_contact(email) do
      nil ->
        handle_error(conn, 404, nil)
      res ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(res))
    end
  end

  # 404 not found / 400 bad request
  @spec update(Plug.Conn.t(), binary(), map()) :: Plug.Conn.t() | no_return()
  def update(conn, email, attrs) do
    case Queries.update_contact(email, attrs) do
      nil ->
        handle_error(conn, 404, nil)
      {:ok, res} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(res))
      {:error, changeset} ->
        handle_error(conn, 400, changeset.errors)
    end
  end

  # 404 not found
  @spec delete(Plug.Conn.t(), binary()) :: Plug.Conn.t() | no_return()
  def delete(conn, email) do
    case Queries.mark_as_delete(email) do
      nil ->
        handle_error(conn, 404, nil)
      _ -> conn
           |> put_resp_header("content-type", "application/json")
           |> send_resp(204, "")
    end
  end

  defp handle_error(conn, 404, _) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(404, "Not found")
  end

  defp handle_error(conn, 400, errors) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(400, "")
  end

end
