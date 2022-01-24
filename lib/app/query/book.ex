defmodule App.Query.Book do

  alias App.Repo
  alias App.Schema.Book

  import Ecto.Query, warn: false


  def new_book do
    %Book{}
    |> Book.changeset()
  end

  def insert_book(params) do
    %Book{}
    |> Book.changeset(params)
    |> Repo.insert()
  end

  def list_books do
    query =
      from b in Book,
        order_by: [desc: :updated_at]

    Repo.all(query)
  end

  def get_book(id) do
    Repo.get(Book, id)
  end

  def edit_book(id) do
    get_book(id)
    |> Book.changeset()
  end

  def update_book(id, params) do
    get_book(id)
    |> Book.changeset(params)
    |> Repo.update()
  end

  def delete_book(id) do
    get_book(id)
    |> Repo.delete()
  end
end