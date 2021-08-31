defmodule BreathWeb.PageController do
  use BreathWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end