defmodule AppWeb.Admin.UploadController do
  use AppWeb, :controller

  plug :ensure_logged_in_admin

  alias App.Query.Upload

  def new(conn, _params) do
    upload = Upload.new_upload()
    render(conn, :new, upload: upload)
  end

  def create(conn, %{"upload" => params}) do
    admin_id = conn.assigns.current_admin.id
    params = Map.put(params, "admin_id", admin_id)
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