defmodule AppWeb.User.PageController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action in [:index]
  
  alias App.Query.User

  def index(conn, _params) do
    users = User.list_users
    render(conn, "index.html", users: users)
  end
end