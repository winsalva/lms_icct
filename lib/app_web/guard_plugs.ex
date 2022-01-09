defmodule AppWeb.GuardPlugs do
  @moduledoc """
  Plugs that can be used to provide authorizations on controller actions.
  """

  alias AppWeb.Router.Helpers, as: Routes
  import Phoenix.Controller #, only: [redirect: 2]
  import Plug.Conn, only: [halt: 1]
  
  @doc """
  Ensure that user is logged in. If user is currently logged in, allows to access the resources, else redirect them to home page and halt the connection.
  """
  def ensure_user_logged_in(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You need to log in first!")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  @doc """
  Ensure that user is an admin and is currently logged in. If user is an admin, allow to access the resources, else redirect user to home page and halt the connection.
  """
  def ensure_admin_logged_in(conn, _opts) do
    if conn.assigns.current_admin do
      conn
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  @doc """
  Ensure that user is an admin and is currently logged in. If user is an admin, allow to access the resources, else redirect user to home page and halt the connection.
  """
  def ensure_superadmin_logged_in(conn, _opts) do
    if conn.assigns.current_admin && conn.assigns.current_admin.super_admin do
      conn
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end