defmodule AppWeb.UploadController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action not in [:show]

  alias App.Query.Upload

  def index(conn, _params) do
    uploads = Upload.list_uploads()
    render(conn, :index, uploads: uploads)
  end

  def new(conn, _params) do
    upload = Upload.new_upload()
    render(conn, :new, upload: upload)
  end

  def create(conn, %{"upload" => %{"category" => category, "title" => title, "description" => description, "file1" => file1, "file2" => file2, "file3" => file3, "file4" => file4}}) do
    admin_id = conn.assigns.current_admin.id
    params = %{
      admin_id: admin_id,
      category: category,
      title: title,
      description: description,
      file1: file1,
      file2: file2,
      file3: file3,
      file4: file4,
      files: [file1, file2, file3, file4]
    }
    case Upload.insert_upload(params) do
      {:ok, _upload} ->
        conn
	|> put_flash(:info, "New room added.")
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = upload} ->
        conn
	|> render(:new, upload: upload)
    end
  end

  def show(conn, %{"id" => id}) do
    upload = Upload.get_upload(id)
    render(conn, :show, upload: upload)
  end

  def edit(conn, %{"id" => id}) do
    upload = Upload.edit_upload(id)
    render(conn, :edit, upload: upload)
  end

  def update(conn, %{"upload" => %{"category" => category, "title" => title, "description" => description, "file1" => file1, "file2" => file2, "file3" => file3, "file4" => file4}, "id" => id}) do
    admin_id = conn.assigns.current_admin.id
    params = %{
      admin_id: admin_id,
      category: category,
      title: title,
      description: description,
      file1: file1,
      file2: file2,
      file3: file3,
      file4: file4,
      files: [file1, file2, file3, file4]
    }
    case Upload.update_upload(id, params) do
      {:ok, _upload} ->
        conn
        |> put_flash(:info, "Updated room details successfully.")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = upload} ->
        conn
        |> render(:edit, upload: upload)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Upload.delete_upload(id) do
      {:ok, _upload} ->
        conn
	|> put_flash(:info, "Room was deleted successfully.")
	|> redirect(to: Routes.page_path(conn, :index))
      _ ->
        conn
	|> put_flash(:error, "Something went wrong.")
	|> redirect(to: Routes.page_path(conn, :index))
    end
  end
end