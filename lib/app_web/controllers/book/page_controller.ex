defmodule AppWeb.Book.PageController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action in [
    :new, :create, :edit, :update, :delete
  ]
  
  alias App.Query.{Book, Lend}

  def index(conn, _params) do
    books = Book.list_books
    render(conn, :index, books: books)
  end
  
  def new(conn, _params) do
    book = Book.new_book
    render(conn, :new, book: book)
  end

  def create(conn, %{"book" => params}) do
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
      |> Map.put("available", params["copies"])
      
    case Book.insert_book(params) do
      {:ok, book} ->
        conn
	|> put_flash(:info, "New book titled \"#{book.title}\" was added successfully!")
	|> redirect(to: Routes.book_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = book} ->
        conn
	|> render(:new, book: book)
    end
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