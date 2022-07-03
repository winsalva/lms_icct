defmodule AppWeb.SessionController do
  use AppWeb, :controller

  alias App.Query.{User, Admin, Lend}

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
        |> redirect(to: Routes.page_path(conn, :transactions))
      false ->
        case User.get_user_by_email_and_password(email, password) do
        %App.Schema.User{} = user ->
	  if password == "123xyz" do
            conn
	    |> put_session(:user_id, user.id)
	    |> configure_session(renew: true)
	    |> put_flash(:info, "Hi #{user.first_name}, you are using default password to login. Please change it to secure your account.")
	    |> redirect(to: Routes.user_account_path(conn, :show, user.id))
	  else
	    conn
	    |> put_session(:user_id, user.id)
	    |> configure_session(renew: true)
	    |> put_flash(:info, "Welcome back #{user.first_name}!")
	    |> redirect(to: Routes.user_account_path(conn, :show, user.id))
	  end
        false ->
          conn
	  |> put_flash(:error, "Email and password combination cannot be found!")
	  |> redirect(to: Routes.session_path(conn, :new))
      end
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end