defmodule AppWeb.UploadController do
  use AppWeb, :controller

  plug :ensure_logged_in_admin when action not in [:show]

  alias App.Query.Upload

  def new(conn, _params) do
    upload = Upload.new_upload()
    render(conn, :new, upload: upload)
  end

  def create(conn, %{"upload" => %{"category" => category, "title" => title, "description" => description, "file1" => file1, "file2" => file2, "file3" => file3, "file4" => file4, "file5" => file5, "file6" => file6, "file7" => file7, "file8" => file8}}) do
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
      file5: file5,
      file6: file6,
      file7: file7,
      file8: file8,
      files: [file1, file2, file3, file4, file5, file6, file7, file8]
    }
    case Upload.insert_upload(params) do
      {:ok, _upload} ->
        conn
	|> put_flash(:info, "New upload added.")
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

  def update(conn, %{"upload" => %{"category" => category, "title" => title, "description" => description, "file1" => file1, "file2" => file2, "file3" => file3, "file4" => file4, "file5" => file5, "file6" => file6, "file7" => file7, "file8" => file8}, "id" => id}) do
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
      file5: file5,
      file6: file6,
      file7: file7,
      file8: file8,
      files: [file1, file2, file3, file4, file5, file6, file7, file8]
    }
    case Upload.update_upload(id, params) do
      {:ok, _upload} ->
        conn
        |> put_flash(:info, "Update an upload successfully.")
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
	|> put_flash(:info, "Upload was deleted successfully.")
	|> redirect(to: Routes.page_path(conn, :index))
      _ ->
        conn
	|> put_flash(:error, "Something went wrong.")
	|> redirect(to: Routes.page_path(conn, :index))
    end
  end

  ## Ensure logged in admin
  defp ensure_logged_in_admin(conn, _options) do
    if conn.assigns.current_admin do
      conn
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end