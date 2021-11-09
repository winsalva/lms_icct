defmodule AppWeb.Admin.SessionController do
  use AppWeb, :controller

  alias App.Query.Admin
  
  def new(conn, _params) do
    case Admin.has_admin?() do
      nil ->
        params = %{
          username: "SUPER ADMIN",
          email: "superadmin@gmail.com",
          super_admin: true,
          password: "superadmin",
          password_confirmation: "superadmin"
        }

        Admin.insert_admin(params)
        render(conn, :new)

      _user ->
        render(conn, :new)
    end
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Admin.get_admin_by_email_and_password(email, password) do
      %App.Schema.Admin{} = admin ->
        conn
        |> put_session(:admin_id, admin.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.page_path(conn, :index))
      false ->
        conn
	|> put_flash(:error, "Email/Password not found!")
	|> redirect(to: Routes.admin_session_path(conn, :new))
    end
  end
end