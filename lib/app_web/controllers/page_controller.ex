defmodule AppWeb.PageController do
  use AppWeb, :controller

  alias App.Query.Book
  
  def index(conn, _params) do
    books = Book.list_books
    render(conn, :index, books: books)
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

  def menus(conn, _params) do
    render(conn, "menus.html")
  end
end