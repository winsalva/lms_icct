defmodule App.Query.Book do

  alias App.Repo
  alias App.Schema.Book


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
    Repo.all(Book)
  end
end