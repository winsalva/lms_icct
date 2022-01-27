defmodule App.Query.Lend do

  alias App.Repo
  alias App.Schema.Lend

  import Ecto.Query, warn: false

  def new_lend do
    %Lend{}
    |> Lend.changeset()
  end

  def insert_lend(params) do
    %Lend{}
    |> Lend.changeset(params)
    |> Repo.insert()
  end

  def list_lends do
    query =
      from l in Lend,
        order_by: [desc: :inserted_at],
	preload: [:user, :book]

    Repo.all(query)
  end

  def get_user_borrowed_books(user_id) do
    query =
      from l in Lend,
        where: l.user_id == ^user_id,
	order_by: [desc: :inserted_at],
	preload: [:book]

    Repo.all(query)
  end

  def user_borrowed?(user_id, book_id) do
    query =
      from l in Lend,
        where: l.user_id == ^user_id and l.book_id == ^book_id and is_nil(l.date_returned)

    Repo.one(query)
  end

  def get_lend(id) do
    Repo.get(Lend, id)
  end

  def update_lend(id, params) do
    get_lend(id)
    |> Lend.changeset(params)
    |> Repo.update()
  end

  def delete_lend(id) do
    get_lend(id)
    |> Repo.delete()
  end
end