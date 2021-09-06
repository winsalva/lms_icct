defmodule Breath.Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Breath.Schema.User
  
  schema "items" do
    belongs_to :user, User
    field :title, :string
    field :description, :string
    timestamps(type: :utc_datetime_usec)
  end

  @allowed_fields [
    :user_id,
    :title,
    :description
  ]

  @required_fields [
    :user_id,
    :title,
    :description
  ]

  @doc false
  def changeset(item, params \\ %{}) do
    item
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
  end
end