defmodule AppWeb.User.PageController do
  use AppWeb, :controller

  plug :ensure_user_logged_in when action in [:show]
  
  alias App.Query.User

  def new(conn, _params) do
    user = User.new_user()
    render(conn, "new.html", user: user)
  end

  def create(conn, %{"user" => params}) do
    case User.insert_user(params) do
      {:ok, _user} ->
        conn
	|> redirect(to: Routes.user_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = user} ->
        conn
	|> render("new.html", user: user)
    end
  end

  def index(conn, _params) do
    users = User.list_users
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = User.get_user(id)
    render(conn, :show, user: user)
  end


  # Ensure user logged in
  defp ensure_user_logged_in(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You need to log in first!")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end