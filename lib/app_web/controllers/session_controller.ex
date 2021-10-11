defmodule AppWeb.SessionController do
  use AppWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end
end