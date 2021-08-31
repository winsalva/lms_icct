defmodule Breath.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :seen, :boolean, default: false
    timestamps([type: :utc_datetime_usec])
  end


  @allowed_fields [
    :first_name,
    :middle_name,
    :last_name,
    :phone_number,
    :seen
  ]

  @required_fields [
    :first_name,
    :middle_name,
    :last_name,
    :phone_number,
    :seen
  ]

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end
end