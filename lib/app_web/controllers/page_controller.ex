defmodule AppWeb.PageController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action in [:users, :transactions]
  
  alias App.Query.{
    Announcement,
    User,
    Admin,
    Book,
    Lend
  }

  @doc """
  Get all transaction records.
  """
  def transactions(conn, _params) do
    released_books = Lend.list_released_books()
    approved_requested_books = Lend.list_approved_requested_books()
    requested_books = Lend.list_requested_books()
    returned_books = Lend.list_returned_books()
    out_of_stock_books = Book.list_out_of_stock_books()
    overdue_books = Lend.list_overdue_books()

    params = [
      returned_books: returned_books,
      released_books: released_books,
      approved_requested_books: approved_requested_books,
      requested_books: requested_books,
      out_of_stock_books: out_of_stock_books,
      overdue_books: overdue_books
    ]
    
    render(conn, "transactions.html", params)
  end

  def users(conn, _params) do
    params = [
      admins: nil,
      students: nil
    ]
    render(conn, "users.html", params)
  end

  @doc """
  Search user.
  """
  def search_users(conn, %{"category" => category, "query" => query}) do
    if category == "Admin" do
      search_result = Admin.search_admin(query)
      params = [
	admins: search_result,
	students: nil
      ]
      render(conn, "users.html", params)
    else
      search_result = User.search_student(query)
      params = [
        admins: nil,
        students: search_result
      ]
      render(conn, "users.html", params)
    end
  end

  def books(conn, _params) do
    params = [
      books: nil
    ]
    render(conn, "books.html", params)
  end

  @doc """
  Search book
  """
  def search_books(conn, %{"category" => category, "title" => title}) do
    result = Book.search_book(category, title)
    params = [
      books: result
    ]
    render(conn, "books.html", params)
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