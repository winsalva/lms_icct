defmodule AppWeb.Announcement.PageController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in

  alias App.Query.Announcement

  def new(conn, _params) do
    announcement = Announcement.new_announcement
    render(conn, :new, announcement: announcement)
  end

  def create(conn, %{"announcement" => params}) do
    admin = conn.assigns.current_admin

    params = Map.put(params, "admin_id", admin.id)
    case Announcement.insert_announcement(params) do
      {:ok, _} ->
        conn
	|> put_flash(:info, "Announcement created!")
	|> redirect(to: Routes.page_path(conn, :home))
      {:error, %Ecto.Changeset{} = announcement} ->
        conn
	|> render(:new, announcement: announcement)
    end
  end


  def edit(conn, %{"id" => id}) do
    announcement = Announcement.edit_announcement(id);
    render(conn, :edit, announcement: announcement)
  end

  def update(conn, %{"announcement" => params, "id" => id}) do
    admin = conn.assigns.current_admin

    params = Map.put(params, "admin_id", admin.id)
    case Announcement.update_announcement(id, params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Announcement content updated successfully!")
        |> redirect(to: Routes.page_path(conn, :home))
      {:error, %Ecto.Changeset{} = announcement} ->
        conn
        |> render(:edit, announcement: announcement)
    end
  end
end