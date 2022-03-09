defmodule App.Query.Lend do

  alias App.Repo
  alias App.Schema.Lend

  import Ecto.Query, warn: false


  @doc """
  List overdue books.
  """
  def list_overdue_books do
    query =
      from l in Lend,
        where: l.status == "Overdue",
	preload: [:user, :book]

    Repo.all(query)
  end
  
  @doc """
  Checks for all overdue pick up dates.
  """
  def overdue_pickup_dates do
    query =
      from l in Lend,
        where: l.status == "Requested" or l.status == "Approved"

    Repo.all(query)
    |> Enum.filter(fn l -> Date.diff(Date.utc_today(), l.pick_up_date) > 0 end)
    |> Enum.each(fn l -> update_lend(l.id, %{status: "Rejected"}) end)
  end

  @doc """
  Check overdue released books.
  """
  def overdue_released_books do
    query =
      from l in Lend,
        where: l.status == "Released",
	preload: [:book]

    Repo.all(query)
    |> Enum.filter(fn l -> Date.diff(Date.utc_today(), Date.add(l.release_date, l.book.lend_duration)) > 0 end)
    |> Enum.each(fn l -> update_lend(l.id, %{status: "Overdue"}) end)
  end

  @doc """
  List all requested books
  """
  def list_requested_books do
    query =
      from l in Lend,
        where: l.status == "Requested",
	order_by: [desc: :inserted_at],
	preload: [:user, :book]

    Repo.all(query)
  end

  @doc """
  List all returned books
  """
  def list_returned_books do
    query =
      from l in Lend,
        where: l.status == "Returned",
        order_by: [desc: :updated_at],
        preload: [:user, :book]

    Repo.all(query)
  end

  @doc """
  List all approved requested books
  """
  def list_approved_requested_books do
    query =
      from l in Lend,
        where: l.status == "Approved",
	order_by: [desc: :inserted_at],
	preload: [:user, :book]

    Repo.all(query)
  end

  @doc """
  List all released books
  """
  def list_released_books do
    query =
      from l in Lend,
        where: l.status == "Released",
        order_by: [desc: :inserted_at],
        preload: [:user, :book]

    Repo.all(query)
  end

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
        where: (l.user_id == ^user_id and l.book_id == ^book_id and l.status == "Requested") or (l.user_id == ^user_id and l.book_id == ^book_id and l.status == "Approved") or (l.user_id == ^user_id and l.book_id == ^book_id and l.status == "Released") or (l.user_id == ^user_id and l.book_id == ^book_id and l.status == "Overdue")
	
    Repo.all(query)
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