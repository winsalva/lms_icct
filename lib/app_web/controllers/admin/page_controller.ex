defmodule AppWeb.Admin.PageController do
  use AppWeb, :controller

  plug :ensure_superadmin_logged_in when action in [:new, :create]
  plug :ensure_admin_logged_in when action not in [:new, :create]

  alias App.Util
  alias App.Query.{
    Admin,
    User,
    Book,
    Lend,
    Announcement
  }

  def list_admins(conn, _params) do
    admins = Admin.list_admins()
    render(conn, "list-admins.html", admins: admins)
  end
  
  def index(conn, _params) do
    admins = Admin.list_admins()
    users = User.list_users
    books = Book.list_books
    lends = Lend.list_lends
    announcement = Announcement.list_announcements

    assigns = [
      admins: admins,
      users: users,
      books: books,
      lends: lends,
      announcement: announcement
    ]
    render(conn, :index, assigns)
  end

  def new(conn, _params) do
    admin = Admin.new_admin()
    render(conn, :new, admin: admin)
  end

  def create(conn, %{"admin" => params}) do
    case Admin.insert_admin(params) do
      {:ok, _admin} ->
        conn
	|> put_flash(:info, "A new admin was added successfully.")
	|> redirect(to: Routes.admin_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = admin} ->
        conn
	|> render(:new, admin: admin)
    end
  end

  def show(conn, %{"id" => id}) do
    admin = Admin.get_admin(id)
    render(conn, :show, admin: admin)
  end
  

  def edit(conn, %{"id" => id}) do
    admin = Admin.edit_admin(id)
    render(conn, :edit, admin: admin)
  end

  def update(conn, %{"admin" => params, "id" => id}) do
    case Admin.update_admin(id, params) do
      {:ok, _admin} ->
        conn
	|> redirect(to: Routes.admin_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = admin} ->
        conn
	|> render(:edit, admin: admin)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Admin.delete_admin(id) do
      {:ok, admin} ->
        conn
	|> put_flash(:info, "#{admin.username} was removed as admin.")
	|> redirect(to: Routes.admin_page_path(conn, :index))
      {:error, %Ecto.Changeset{} = _admin} ->
        conn
	|> put_flash(:info, "Unable to delete this account.")
	|> redirect(to: Routes.admin_page_path(conn, :index))
    end
  end
end
 