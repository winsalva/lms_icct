defmodule AppWeb.User.AccountController do
  use AppWeb, :controller

  plug :ensure_user_logged_in when action in [
    :change_password,
    :update_password,
    :edit_name,
    :update_name,
    :show
  ]
  
  alias App.Query.{
    User,
    Reservation
  }

  def change_password(conn, %{"id" => id}) do
    user = User.edit_user(id)
    render(conn, "change-password.html", user: user)
  end

  def update_password(conn, %{"id" => id, "user" => %{"current_password" => current_password, "password" => password, "password_confirmation" => password_confirmation}}) do
    user_email = conn.assigns.current_user.email
    user_id = conn.assigns.current_user.id

    with _user = %App.Schema.User{} <- User.get_user_by_email_and_password(user_email, current_password),
      {:ok, _user} <- User.update_user_password(id, %{password: password, password_confirmation: password_confirmation}) do
        conn
        |> put_flash(:info, "Your password was updated successfully.")
        |> redirect(to: Routes.user_account_path(conn, :show, user_id))
    else
      false ->
        conn
        |> put_flash(:error, "Something went wrong. Failed to update your password!")
        |> redirect(to: Routes.user_account_path(conn, :show, user_id))
      {:error, %Ecto.Changeset{} = user} ->
        conn
        |> render("change-password.html", user: user)
    end
  end
  
  def edit_name(conn, %{"id" => id}) do
    user = User.edit_user(id)
    render(conn, "edit-name.html", user: user)
  end

  def update_name(conn, %{"id" => id, "user" => %{"first_name" => first_name, "last_name" => last_name, "password" => password}}) do
    user_email = conn.assigns.current_user.email
    user_id = conn.assigns.current_user.id

    with _user = %App.Schema.User{} <- User.get_user_by_email_and_password(user_email, password),
      {:ok, _user} <- User.update_user(id, %{first_name: first_name, last_name: last_name}) do
        conn
	|> put_flash(:info, "Your name was updated successfully.")
	|> redirect(to: Routes.user_account_path(conn, :show, user_id))
    else
      false ->
        conn
	|> put_flash(:error, "Something went wrong. Failed to update your name!")
	|> redirect(to: Routes.user_account_path(conn, :show, user_id))
      {:error, %Ecto.Changeset{} = user} ->
        conn
	|> render("edit-name.html", user: user)
    end
  end

  def new(conn, _params) do
    user = User.new_user()
    render(conn, "new.html", user: user)
  end

  def create(conn, %{"user" => params}) do
    case User.insert_user(params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = user} ->
        conn
        |> render("new.html", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = User.get_user(id)
    reservations = Reservation.get_reservations_for_user(id)
    params = [
      user: user,
      reservations: reservations
    ]
    render(conn, :show, params)
  end
end