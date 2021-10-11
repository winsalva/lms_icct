defmodule AppWeb.User.PageController do
  use AppWeb, :controller

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
end