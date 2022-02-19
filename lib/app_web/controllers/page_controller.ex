defmodule AppWeb.PageController do
  use AppWeb, :controller

  alias App.Query.Book
  
  def index(conn, _params) do
    conn
    |> redirect(to: Routes.page_path(conn, :home))
  end

  def home(conn, _params) do
    conn
    |> render("index.html")
  end

  def term_of_use(conn, _params) do
    render(conn, "term-of-use.html")
  end

  def privacy_policy(conn, _params) do
    render(conn, "privacy-policy.html")
  end

  def about_us(conn, _params) do
    render(conn, "about-us.html")
  end

  def contact_us(conn, _params) do
    render(conn, "contact-us.html")
  end

  def menus(conn, _params) do
    render(conn, "menus.html")
  end
end