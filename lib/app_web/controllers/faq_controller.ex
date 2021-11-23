defmodule AppWeb.FaqController do
  use AppWeb, :controller

  plug :ensure_admin_logged_in when action not in [:index, :show]
  
  alias App.Util
  alias App.Util.Faq

  def index(conn, _params) do
    faqs = Util.list_faqs()
    render(conn, "index.html", faqs: faqs)
  end

  def new(conn, _params) do
    changeset = Util.change_faq(%Faq{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"faq" => faq_params}) do
    admin_id = conn.assigns.current_admin.id
    faq_params = Map.put(faq_params, "admin_id", admin_id)
    case Util.create_faq(faq_params) do
      {:ok, faq} ->
        conn
        |> put_flash(:info, "Faq created successfully.")
        |> redirect(to: Routes.faq_path(conn, :show, faq))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    faq = Util.get_faq!(id)
    render(conn, "show.html", faq: faq)
  end

  def edit(conn, %{"id" => id}) do
    faq = Util.get_faq!(id)
    changeset = Util.change_faq(faq)
    render(conn, "edit.html", faq: faq, changeset: changeset)
  end

  def update(conn, %{"id" => id, "faq" => faq_params}) do
    faq = Util.get_faq!(id)

    case Util.update_faq(faq, faq_params) do
      {:ok, faq} ->
        conn
        |> put_flash(:info, "FAQ updated successfully.")
        |> redirect(to: Routes.faq_path(conn, :show, faq))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", faq: faq, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    faq = Util.get_faq!(id)
    {:ok, _faq} = Util.delete_faq(faq)

    conn
    |> put_flash(:info, "FAQ deleted successfully.")
    |> redirect(to: Routes.faq_path(conn, :index))
  end
end
