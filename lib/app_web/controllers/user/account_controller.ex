defmodule AppWeb.User.AccountController do
  use AppWeb, :controller

  plug :ensure_user_logged_in when action in [
    :change_password,
    :update_password,
    :edit_name,
    :update_name
  ]
   
  alias App.Query.{User, Lend}

  def reset_password(conn, %{"id" => id}) do
    default_password = "123xyz"
    params = %{
      password: default_password,
      password_confirmation: default_password
    }
    case User.update_user_password(id, params) do
      {:ok, user} ->
        conn
	|> put_flash(:info, "#{user.first_name}\'s password was reset to default!")
	|> redirect(to: Routes.user_account_path(conn, :show, user.id))
      _ ->
        conn
	|> put_flash(:error, "Something went wrong!")
	|> redirect(to: Routes.user_account_path(conn, :show, id))
    end
  end

  def approve_disapprove_user(conn, %{"id" => id}) do
    user = User.get_user(id)
    if user.approve do
      User.update_user(id, %{approve: false})
    else
      User.update_user(id, %{approve: true})
    end

    conn
    |> redirect(to: Routes.user_page_path(conn, :index))
  end

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

  def update_name(conn, %{"id" => id, "user" => %{"first_name" => first_name, "last_name" => last_name, "password" => password, "email" => email, "library_id" => library_id, "year" => year, "section" => section, "course" => course}}) do
    user_email = conn.assigns.current_user.email
    user_id = conn.assigns.current_user.id

    params = %{
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "library_id": library_id,
      "year": year,
      "section": section,
      "course": course
    }

    with _user = %App.Schema.User{} <- User.get_user_by_email_and_password(user_email, password),
      {:ok, _user} <- User.update_user(id, params) do
        conn
	|> put_flash(:info, "Your profile was updated successfully.")
	|> redirect(to: Routes.user_account_path(conn, :show, user_id))
    else
      false ->
        conn
	|> put_flash(:error, "Something went wrong. Failed to update your profile.")
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

  def create(conn, %{"user" => %{"accounts" => accounts}}) do
    [_|s_accounts] =
      String.split(accounts, "#")
      |> Enum.map(&String.replace(&1, ["\r","\n"], ""))
      |> Enum.map(&String.split(&1, ","))

      Enum.map(s_accounts, fn [lrn, fname, lname] ->
        id = lrn
	fname = fname
	lname = lname
	email = String.downcase(String.first(fname) <> lname <> "@pcu.edu.ph")
	password = "123xyz"
	User.insert_user(%{student_id: id, first_name: fname, last_name: lname, email: email, password: password, password_confirmation: password, approve: true}) end)
    conn
    |> put_flash(:info, "Adding new student accounts... done!")
    |> redirect(to: Routes.page_path(conn, :users))
  end

  def show(conn, %{"id" => id}) do
    {id, _} = Integer.parse(id)
    if conn.assigns.current_user && conn.assigns.current_user.id == id || conn.assigns.current_admin do
      if conn.assigns.current_user && conn.assigns.current_user.id == id do
        User.update_user(id, %{seen_approval: true})
      end
      
      user = User.get_user(id)
      render(conn, :show, user: user)
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def user_transactions(conn, %{"user_id" => user_id}) do
    borrows = Lend.get_user_borrowed_books(user_id)
    render(conn, "user-transactions.html", borrows: borrows)
  end

  @doc """
  Delete a user's account.
  """
  def delete(conn, %{"id" => id}) do
    case User.delete_user(id) do
      {:ok, user} ->
        conn
	|> put_flash(:info, "#{user.first_name}\'s account was deleted successfully.")
	|> redirect(to: Routes.user_page_path(conn, :index))
      {:error, _} ->
        conn
	|> put_flash(:error, "Something went wrong.")
	|> redirect(to: Routes.user_page_path(conn, :index))
    end
  end
end