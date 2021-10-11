defmodule App.Query.Item do
  alias App.Repo
  alias App.Schema.Item


  def new_item do
    %Item{}
    |> Item.changeset()
  end

  def insert_item(params) do
    %Item{}
    |> Item.changeset(params)
    |> Repo.insert()
  end

  def list_items do
    Repo.all(Item)
  end

  def get_item(id) do
    Repo.get(Item, id)
  end

  def edit_item(id) do
    get_item(id)
    |> Item.changeset()
  end

  def update_item(id, params) do
    get_item(id)
    |> Item.changeset(params)
    |> Repo.update()
  end

  def delete_item(id) do
    get_item(id)
    |> Repo.delete()
  end
end