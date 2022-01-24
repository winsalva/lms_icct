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
        where: l.user_id == ^user_id

    Repo.all(query)
  end

  def get_lend(id) do
    Repo.get(Lend, id)
  end
end