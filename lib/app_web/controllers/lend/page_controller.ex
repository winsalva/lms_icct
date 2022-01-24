defmodule AppWeb.Lend.PageController do
  use AppWeb, :controller

  plug :ensure_user_logged_in when action in [
    :new, :create
  ]
  plug :ensure_admin_logged_in when action in [
    :index
  ]
  
  alias App.Query.{Lend, Book}

  def new(conn, %{"book_id" => book_id}) do
    book = Book.get_book(book_id)
    lend = Lend.new_lend
    render(conn, :new, book: book, lend: lend)
  end

  def create(conn, %{"lend" => params, "book_id" => book_id}) do
    book = Book.get_book(book_id)
    user = conn.assigns.current_user
    params =
      Map.put(params, "book_id", book_id)
      |> Map.put("user_id", user.id)

    case Lend.insert_lend(params) do
      {:ok, lend} ->
        conn
	|> put_flash(:info, "You have borrowed a book titled \"#{book.title}\" successfully.")
	|> redirect(to: Routes.book_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = lend} ->
        conn
	|> render(:new, book: book, lend: lend)
    end
  end

  def index(conn, _params) do
    lends = Lend.list_lends
    render(conn, :index, lends: lends)
  end
end