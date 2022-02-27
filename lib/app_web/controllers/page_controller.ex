defmodule AppWeb.PageController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action in [:users]
  alias App.Query.{Announcement, User, Admin, Book}

  def users(conn, _params) do
    admins = Admin.list_admins()
    users = User.list_users
    params = [
      admins: admins,
      users: users
    ]
    render(conn, "users.html", params)
  end

  def books(conn, _params) do
    books = Book.list_books()
    render(conn, "books.html", books: books)
  end
  
  def index(conn, _params) do
    conn
    |> redirect(to: Routes.page_path(conn, :home))
  end

  def home(conn, _params) do
    announcement = Announcement.list_announcements
    conn
    |> render("index.html", announcement: announcement)
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