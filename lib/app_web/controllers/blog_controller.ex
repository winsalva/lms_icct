defmodule AppWeb.BlogController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action not in [:show, :index]
  
  alias App.Query.Blog
  
  def index(conn, _params) do
    blogs = Blog.list_blogs
    render(conn, :index, blogs: blogs)
  end

  def new(conn, _params) do
    blog = Blog.new_blog
    render(conn, :new, blog: blog)
  end

  def create(conn, %{"blog" => params}) do
    admin_id = conn.assigns.current_admin.id
    params = Map.put(params, "admin_id", admin_id)
    case Blog.insert_blog(params) do
      {:ok, _blog} ->
        conn
	|> put_flash(:info, "New blog added successfully!")
	|> redirect(to: Routes.blog_path(conn, :index))
      {:error, %Ecto.Changeset{} = blog} ->
        conn
	|> render(:new, blog: blog)
    end
  end

  def show(conn, %{"id" => id}) do
    blog = Blog.get_blog(id)
    case App.as_html(blog.body) do
      {:ok, content, _} ->
	conn
	|> render(:show, blog: blog, content: content, page_title: blog.title)
      {:error, _content, _list} ->
	conn
	|> put_flash(:error, "Something went wrong!")
	|> redirect(to: Routes.blog_path(conn, :index))
    end	
  end

  def edit(conn, %{"id" => id}) do
    blog = Blog.edit_blog(id)
    render(conn, :edit, blog: blog)
  end

  def update(conn, %{"blog" => params, "id" => id}) do
    admin_id = conn.assigns.current_admin.id
    params = Map.put(params, "admin_id", admin_id)
    case Blog.update_blog(id, params) do
      {:ok, _blog} ->
        conn
	|> put_flash(:info, "Updated a blog successfully.")
	|> redirect(to: Routes.blog_path(conn, :show, id))
      {:error, %Ecto.Changeset{} = blog} ->
        render(conn, :edit, blog: blog)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Blog.delete_blog(id) do
      {:ok, _blog} ->
        conn
	|> put_flash(:info, "A blog was deleted successfully.")
	|> redirect(to: Routes.blog_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong!")
        |> redirect(to: Routes.blog_path(conn, :index))
    end
  end


  # Ensure admin logged in
  defp ensure_admin_logged_in(conn, _opts) do
    if conn.assigns.current_admin do
      conn
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end