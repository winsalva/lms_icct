defmodule App.Query.Admin do
  alias App.Repo
  alias App.Schema.Admin
  import Ecto.Query, warn: false

  def has_admin? do
    case Repo.all(Admin) do
      [] -> nil
      _ -> true
    end
  end

  def new_admin do
    %Admin{}
    |> Admin.changeset()
  end

  def insert_admin(params) do
    %Admin{}
    |> Admin.changeset_with_password(params)
    |> Repo.insert()
  end

  def list_admins do
    Repo.all(Admin)
  end

  def get_admin(id) do
    Repo.get(Admin, id)
  end

  def get_admin_by(attr) do
    Repo.get_by(Admin, attr)
  end

  def edit_admin(id) do
    get_admin(id)
    |> Admin.changeset()
  end

  def update_admin(id, params) do
    get_admin(id)
    |> Admin.changeset(params)
    |> Repo.update()
  end

  def delete_admin(id) do
    get_admin(id)
    |> Repo.delete()
  end

  @doc """
  Get admin by email and password.
  """
  def get_admin_by_email_and_password(email, password) do
    with admin when not is_nil(admin) <- get_admin_by(%{email: String.trim(email)}),
         true <- App.Password.verify_pass(password, admin.hashed_password) do
      admin
    else
      _ -> App.Password.no_user_verify
    end
  end
end