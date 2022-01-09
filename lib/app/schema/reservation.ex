defmodule App.Schema.Reservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reservations" do
    belongs_to :user, App.Schema.User
    belongs_to :upload, App.Schema.Upload
    field :date, :date
    field :no_of_guests, :integer
    timestamps()
  end

  @allowed_fields [
    :user_id,
    :upload_id,
    :date,
    :no_of_guests
  ]

  @doc false
  def changeset(reservation, params \\ %{}) do
    reservation
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:upload)
  end
end