defmodule AppWeb.Admin.AccountController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action in [
    :edit_usernane,
    :update_username,
    :change_password,
    :update_password
  ]
  
  alias App.Query.Admin

  def edit_username(conn, %{"id" => id}) do
    admin = Admin.edit_admin(id)
    render(conn, "edit-username.html", admin: admin)
  end

  def update_username(conn, %{"id" => id, "admin" => %{"username" => username, "password" => password}}) do
    admin_email = conn.assigns.current_admin.email
    admin_id = conn.assigns.current_admin.id

    with _admin = %App.Schema.Admin{} <- Admin.get_admin_by_email_and_password(admin_email, password),
      {:ok, _admin} <- Admin.update_admin(id, %{username: username}) do
        conn
        |> put_flash(:info, "Your admin username was updated successfully.")
        |> redirect(to: Routes.admin_page_path(conn, :show, admin_id))
    else
      false ->
        conn
        |> put_flash(:error, "Something went wrong. Failed to update your username!")
        |> redirect(to: Routes.admin_page_path(conn, :show, admin_id))
      {:error, %Ecto.Changeset{} = admin} ->
        conn
        |> render("edit-username.html", admin: admin)
    end
  end

  def change_password(conn, %{"id" => id}) do
    admin = Admin.edit_admin(id)
    render(conn, "change-password.html", admin: admin)
  end

  def update_password(conn, %{"id" => id, "admin" => %{"current_password" => current_password, "password" => password, "password_confirmation" => password_confirmation}}) do
    admin_email = conn.assigns.current_admin.email
    admin_id = conn.assigns.current_admin.id

    with _admin = %App.Schema.Admin{} <- Admin.get_admin_by_email_and_password(admin_email, current_password),
      {:ok, _admin} <- Admin.update_admin_password(id, %{password: password, password_confirmation: password_confirmation}) do
        conn
        |> put_flash(:info, "Your password was updated successfully.")
        |> redirect(to: Routes.admin_page_path(conn, :show, admin_id))
    else
      false ->
        conn
        |> put_flash(:error, "Something went wrong. Failed to update your password!")
        |> redirect(to: Routes.admin_page_path(conn, :show, admin_id))
      {:error, %Ecto.Changeset{} = admin} ->
        conn
        |> render("change-password.html", admin: admin)
    end
  end
end