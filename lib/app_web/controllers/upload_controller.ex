defmodule AppWeb.UploadController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action not in [:show, :create_reservation]
  plug :ensure_user_logged_in when action in [:create_reservation]

  alias App.Query.{
    Upload,
    Reservation
  }

  def index(conn, _params) do
    uploads = Upload.list_uploads()
    render(conn, :index, uploads: uploads)
  end

  def new(conn, _params) do
    upload = Upload.new_upload()
    render(conn, :new, upload: upload)
  end

  def create(conn, %{"upload" => %{"category" => category, "title" => title, "description" => description, "file1" => file1, "file2" => file2, "file3" => file3, "file4" => file4, "rates" => rates}}) do
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
      rates: rates,
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
    reservation = Reservation.new_reservation
    params = [
      upload: upload,
      reservation: reservation
    ]
    render(conn, :show, params)
  end

  def create_reservation(conn, %{"reservation" => params, "upload_id" => upload_id}) do
    user = conn.assigns.current_user
    params =
      Map.put(params, "upload_id", upload_id)
      |> Map.put("user_id", user.id)
    
    case Reservation.insert_reservation(params) do
      {:ok, _reservation} ->
        conn
	|> put_flash(:info, "You made a reservation.")
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = reservation} ->
        upload = Upload.get_upload(upload_id)
	params = [
	  upload: upload,
	  reservation: reservation
	]
	render(conn, :show, params)
    end
  end

  def edit(conn, %{"id" => id}) do
    upload = Upload.edit_upload(id)
    render(conn, :edit, upload: upload)
  end

  def update(conn, %{"upload" => %{"category" => category, "title" => title, "description" => description, "file1" => file1, "file2" => file2, "file3" => file3, "file4" => file4, "rates" => rates}, "id" => id}) do
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
      rates: rates,
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