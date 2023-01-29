defmodule AppWeb.Book.PageController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action in [
    :new, :create, :edit, :update, :delete
  ]
  
  alias App.Query.{Book, Lend}


  @doc """
  Add admin remark for returned book condition
  """
  def return_book_condition(conn, %{"book_id" => book_id, "id" => id}) do
    lend_details = %{
      book_id: book_id,
      id: id
    }
    render(conn, "return-book-condition.html", lend_details: lend_details)
  end

  def index(conn, _params) do
    books = Book.list_books
    render(conn, :index, books: books)
  end
  
  def new(conn, _params) do
    book = Book.new_book
    render(conn, :new, book: book)
  end

  def create_book(conn, %{"book" => %{"isbn" => isbn, "accession_number" => accession_number, "title" => title, "author" => author, "category" => category, "copies" => copies}}) do

    admin_id = conn.assigns.current_admin.id
    lend_duration = if category == "Circulati\
on", do: 3, else: 7

    copies =
    cond do
      Integer.parse(copies) == :error -> 1
      {num, _} = Integer.parse(copies) ->
        if num < 1 do
	  0
	else
	  num
	end
      true -> 1
    end

    available =
      if copies > 0 do
        copies
      else
        0
      end

    params = %{
      isbn: isbn,
      title: title,
      accession_number: accession_number,
      author: author,
      category: category,
      available: available,
      copies: copies,
      admin_id: admin_id,
      lend_duration: lend_duration}
    
    case Book.insert_book(params) do
      {:ok, book} ->
        conn
	|> put_flash(:info, "#{book.title} was added successfully!")
	|> redirect(to: Routes.book_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = book} ->
        conn
	|> render(:new, book: book)
    end
  end

  def create(conn, %{"book" => %{"books" => params}}) do
    admin = conn.assigns.current_admin

    [_|books] =
      String.split(params, "#")
      |> Enum.map(&String.replace(&1, ["\r","\n"], ""))
      |> Enum.map(&String.split(&1, ","))

      Enum.map(books, fn [isbn, title, author, category, copies] ->
        isbn = isbn
        title = title
        author = author
	category = category
	{available, _} = Integer.parse(copies)
        admin_id = admin.id
	lend_duration = if category == "Circulation", do: 3, else: 7 
        Book.insert_book(%{isbn: isbn, title: title, author: author, category: category, available: available, copies: available, admin_id: admin_id, lend_duration: lend_duration}) end)

    conn
    |> put_flash(:info, "New books  was added successfully!")
    |> redirect(to: Routes.book_page_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    book = Book.edit_book(id)
    render(conn, :edit, book: book)
  end

  def update(conn, %{"book" => params, "id" => id}) do
    category =
      if params["category"] == "Circulation" do
        3
      else
        7
      end

    admin = conn.assigns.current_admin
    params =
      Map.put(params, "admin_id", admin.id)
      |> Map.put("lend_duration", category)
     
    case Book.update_book(id, params) do
      {:ok, book} ->
        conn
	|> put_flash(:info, "Book titled \"#{book.title}\" details was updated successfully!")
	|> redirect(to: Routes.book_page_path(conn, :show, book.id))
      {:error, %Ecto.Changeset{} = book} ->
        conn
	|> render(:edit, book: book)
    end
  end

  def show(conn, %{"id" => id}) do
    if conn.assigns.current_user do
      borrow = Lend.user_borrowed?(conn.assigns.current_user.id, id)
      book = Book.get_book(id)
      params = [
        borrow: borrow,
	book: book
      ]
      render(conn, :show, params)
    else
      book = Book.get_book(id)
      borrow = []
      params = [
        book: book,
	borrow: borrow
      ]
      render(conn, :show, params)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Book.delete_book(id) do
      {:ok, book} ->
        conn
	|> put_flash(:info, "Book titled \"#{book.title}\" was deleted successfully")
	|> redirect(to: Routes.book_page_path(conn, :index))
      {:error, _} ->
        conn
	|> put_flash(:error, "Something went wrong!")
	|> redirect(to: Routes.book_page_path(conn, :index))
    end
  end	
end