defmodule Contacts.Controler do
  @moduledoc """
  Controller module to interact with the backend
  """
  import Plug.Conn
  require Logger
  alias Contacts.Queries
  alias Contacts.Utils

  @doc """
  List contacts
  """
  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t() | no_return()
  def index(conn, params) do
    Utils.debug "[#{inspect(__MODULE__)}] Call index function #{inspect(conn)}"
    res = Queries.list_contact(params)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(res))
  end

  @doc """
  Create a contact
  Throw 400 if try to create a contact with invalid data
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t() | no_return()
  def create(conn, attrs) do
    Utils.debug "[#{inspect(__MODULE__)}] Call create function #{inspect(conn)}"
    case Queries.create_contact(attrs) do
      {:ok, res} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(res))
      {:error, changeset} ->
        Utils.warn "[#{inspect(__MODULE__)}] Call create function with bad params #{inspect(changeset)}"
        handle_error(conn, 400, changeset.errors)
    end
  end

  @doc """
  Get a contact
  Throw 404 if contact not exists
  """
  @spec show(Plug.Conn.t(), binary()) :: Plug.Conn.t() | no_return()
  def show(conn, email) do
    Utils.debug "[#{inspect(__MODULE__)}] Call show function #{inspect(conn)}"
    case Queries.get_contact(email) do
      nil ->
        handle_error(conn, 404, nil)
      res ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(res))
    end
  end

  @doc """
  Update a contact
  Throw 400 if try to update a contact with invalid data
        404 if contact not exist
  """
  @spec update(Plug.Conn.t(), binary(), map()) :: Plug.Conn.t() | no_return()
  def update(conn, email, attrs) do
    Utils.debug "[#{inspect(__MODULE__)}] Call update function #{inspect(conn)}"
    case Queries.update_contact(email, attrs) do
      nil ->
        handle_error(conn, 404, nil)
      {:ok, res} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(res))
      {:error, changeset} ->
        Utils.warn "[#{inspect(__MODULE__)}] Call update function with bad params #{inspect(changeset)}"
        handle_error(conn, 400, changeset.errors)
    end
  end

  @doc """
  Delete a contact
  Throw 404 if contact not exist
  """
  @spec delete(Plug.Conn.t(), binary()) :: Plug.Conn.t() | no_return()
  def delete(conn, email) do
    Utils.debug "[#{inspect(__MODULE__)}] Call delete function #{inspect(conn)}"
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

  defp handle_error(conn, 400, _errors) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(400, "")
  end

end
