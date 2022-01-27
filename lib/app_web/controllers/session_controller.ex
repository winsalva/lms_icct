defmodule AppWeb.SessionController do
  use AppWeb, :controller

  alias App.Query.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case User.get_user_by_email_and_password(email, password) do
      %App.Schema.User{} = user ->
        conn
	|> put_session(:user_id, user.id)
	|> configure_session(renew: true)
	|> put_flash(:info, "Welcome back #{user.first_name}!")
	|> redirect(to: Routes.user_account_path(conn, :show, user.id))
      false ->
        conn
	|> put_flash(:error, "Email and password combination cannot be found!")
	|> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end