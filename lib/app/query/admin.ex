defmodule App.Query.Admin do
  alias App.Repo
  alias App.Schema.Admin


  def new_admin do
    %Admin{}
    |> Admin.changeset()
  end

  def insert_admin(params) do
    %Admin{}
    |> Admin.changeset(params)
    |> Repo.insert()
  end

  def list_admins do
    Repo.all(Admin)
  end

  def get_admin(id) do
    Repo.get(Admin, id)
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
end