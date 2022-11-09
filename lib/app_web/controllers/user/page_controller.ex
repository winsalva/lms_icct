defmodule AppWeb.User.PageController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action in [:index]
  
  alias App.Query.User

  def index(conn, _params) do
    users = User.list_users
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    user = User.new_user
    render(conn, :new, user: user)
  end

  def create(conn, %{"user" => params}) do
    case User.insert_user(params) do
      {:ok, _user} ->
        conn
	|> put_flash(:info, "Your account was successfully created. Please wait for an admin approval.")
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = user} ->
        conn
	|> render(:new, user: user)
    end
  end
end