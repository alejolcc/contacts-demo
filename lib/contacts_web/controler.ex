defmodule Contacts.Controler do
  @moduledoc """
  Controller module to interact with the backend
  """
  import Plug.Conn
  require Logger
  alias Contacts.Queries
  alias Contacts.Utils

  @doc """
  Controler function for `GET /contacts`

  Return a JSON with a list of the contacts
  ## Status Code
    `200`
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
  Controler function for `POST /contacts`

  Return a JSON with the created contact
  ## Status Code
    `200`,`400`
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
  Controler function for `GET /contacts/:email`

  Return a JSON of the contact
  ## Status Code
    `200`,`404`
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
  Controler function for `PUT /contacts/:email`

  Return a JSON with updated contact
  ## Status Code
    `200`,`400`,`404`
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
  Controler function for `DELETE /contacts/:email`
  
  ## Status Code
    `204`,`404`  
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
