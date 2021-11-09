defmodule AppWeb.Admin.PageController do
  use AppWeb, :controller

  plug :ensure_logged_in_admin


  alias App.Query.Admin
  
  def index(conn, _params) do
    admins = Admin.list_admins()
    render(conn, :index, admins: admins)
  end

  def new(conn, _params) do
    admin = Admin.new_admin()
    render(conn, :new, admin: admin)
  end

  def create(conn, %{"admin" => params}) do
    case Admin.insert_admin(params) do
      {:ok, _admin} ->
        conn
	|> put_flash(:info, "A new admin was added successfully.")
	|> redirect(to: Routes.admin_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = admin} ->
        conn
	|> render(:new, admin: admin)
    end
  end

  def edit(conn, %{"id" => id}) do
    admin = Admin.edit_admin(id)
    render(conn, :edit, admin: admin)
  end

  def update(conn, %{"admin" => params, "id" => id}) do
    case Admin.update_admin(id, params) do
      {:ok, _admin} ->
        conn
	|> redirect(to: Routes.admin_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = admin} ->
        conn
	|> render(:edit, admin: admin)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Admin.delete_admin(id) do
      {:ok, admin} ->
        conn
	|> put_flash(:info, "#{admin.username} was removed as admin.")
	|> redirect(to: Routes.admin_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = _admin} ->
        conn
	|> put_flash(:info, "Unable to delete this account.")
	|> redirect(to: Routes.admin_page_path(conn, :index))
    end
  end



  ## Ensure logged in admin
  defp ensure_logged_in_admin(conn, _options) do
    if conn.assigns.current_admin do
      conn
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
 