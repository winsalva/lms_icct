defmodule AppWeb.SessionController do
  use AppWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end