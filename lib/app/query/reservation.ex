defmodule App.Query.Reservation do
  alias App.Repo
  alias App.Schema.Reservation

  import Ecto.Query, warn: false

  def new_reservation do
    %Reservation{}
    |> Reservation.changeset()
  end

  def insert_reservation(params) do
    %Reservation{}
    |> Reservation.changeset(params)
    |> Repo.insert()
  end

  def list_reservations do
    query =
      from r in Reservation,
        preload: [:user, :upload],
	order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  def get_reservation(id) do
    Repo.get(Reservation, id)
  end

  def get_reservations_for_user(user_id) do
    query =
      from r in Reservation,
        where: r.user_id == ^user_id,
	order_by: [desc: :updated_at],
	preload: [:upload]

    Repo.all(query)
  end
end