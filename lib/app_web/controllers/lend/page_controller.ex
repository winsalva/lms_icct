defmodule AppWeb.Lend.PageController do
  use AppWeb, :controller

  plug :ensure_user_logged_in when action in [
    :new, :create
  ]
  plug :ensure_admin_logged_in when action in [
    :index
  ]
  
  alias App.Query.{Lend, Book}

  @doc """
  Get all out of stock books.
  """
  def out_of_stock_books(conn, _params) do
    out_of_stock_books = Book.list_out_of_stock_books()
    params = [
      books: out_of_stock_books
    ]
    render(conn, "out-of-stock-books.html", params)
  end

  @doc """
  Get all returned books.
  """
  def returned_books(conn, _params) do
    returned_books = Lend.list_returned_books()
    render(conn, "returned-books.html", returned_books: returned_books)
  end

  @doc """
  Get all approved requested books.
  """
  def approved_requested_books(conn, _params) do
    approved_requested_books = Lend.list_approved_requested_books()
    render(conn, "approved-requested-books.html", approved_requested_books: approved_requested_books)
  end

  @doc """
  Get all released books.
  """
  def released_books(conn, _params) do
    released_books = Lend.list_released_books()
    render(conn, "released-books.html", released_books: released_books)
  end

  @doc """
  Return a book
  """
  def return_book(conn, %{"id" => id}) do
    case Lend.update_lend(id, %{status: "Returned", accept_term: true}) do
      {:ok, _lend} ->
        conn
        |> put_flash(:info, "A book was returned successfully.")
        |> redirect(to: Routes.lend_page_path(conn, :released_books))
      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong!")
        |> redirect(to: Routes.lend_page_path(conn, :released_books))
    end
  end
  
  @doc """
  Approve requested book
  """
  def approve_request(conn, %{"id" => id}) do
    case Lend.update_lend(id, %{status: "Approved", accept_term: true}) do
      {:ok, _lend} ->
        conn
	|> put_flash(:info, "A requested book was approved successfully.")
	|> redirect(to: Routes.lend_page_path(conn, :requested_books))
      {:error, _} ->
        conn
	|> put_flash(:error, "Something went wrong!")
	|> redirect(to: Routes.lend_page_path(conn, :requested_books))
    end
  end

  @doc """
  Reject requested book
  """
  def reject_request(conn, %{"id" => id}) do
    case Lend.update_lend(id, %{status: "Rejected", accept_term: true}) do
      {:ok, _lend} ->
        conn
        |> put_flash(:info, "A requested book was rejected successfully.")
        |> redirect(to: Routes.lend_page_path(conn, :requested_books))
      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong!")
        |> redirect(to: Routes.lend_page_path(conn, :requested_books))
    end
  end

  @doc """
  Release a book.
  """
  def release_book(conn, %{"id" => id}) do
    case Lend.update_lend(id, %{status: "Released", accept_term: true}) do
      {:ok, _lend} ->
        conn
        |> put_flash(:info, "Released a book successfully.")
        |> redirect(to: Routes.lend_page_path(conn, :approved_requested_books))
      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong!")
        |> redirect(to: Routes.lend_page_path(conn, :approved_requested_books))
    end
  end

  @doc """
  Get all requested books
  """
  def requested_books(conn, _params) do
    requested_books = Lend.list_requested_books()
    render(conn, "requested-books.html", requested_books: requested_books)
  end

  def new(conn, %{"book_id" => book_id}) do
    book = Book.get_book(book_id)
    lend = Lend.new_lend
    render(conn, :new, book: book, lend: lend)
  end

  def create(conn, %{"lend" => params, "book_id" => book_id}) do
    book = Book.get_book(book_id)
    reserved = book.reserved
    available = book.available
    
    user = conn.assigns.current_user
    pick_up_date =
      if params["pick_up_date"] == "Tomorrow" do
        Date.add(Date.utc_today(), 1)
      else
        Date.add(Date.utc_today(), 2)
      end
      
    params =
      Map.put(params, "book_id", book_id)
      |> Map.put("user_id", user.id)
      |> Map.put("status", "Requested")
      |> Map.put("pick_up_date", pick_up_date)

    case Lend.insert_lend(params) do
      {:ok, lend} ->
        # Update reserved and available field values
        Book.update_book(book.id, %{reserved: reserved + 1, available: available - 1})
	
        conn
	|> put_flash(:info, "You requested to reserve a book titled \"#{book.title}\". Kindly check your transaction records for the status of your requested book(s).")
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

  def return_lend(conn, %{"id" => id}) do
    params = %{date_returned: Date.utc_today()}
    case Lend.update_lend(id, params) do
      {:ok, _} ->
        conn
	|> put_flash(:info, "Book was returned succesafully.")
	|> redirect(to: Routes.user_account_path(conn, :show, conn.assigns.current_user.id))
      {:error, _} ->
        conn
	|> put_flash(:error, "Something went wrong")
	|> redirect(to: Routes.user_account_path(conn, :show, conn.assigns.current_user.id))
    end
  end
end