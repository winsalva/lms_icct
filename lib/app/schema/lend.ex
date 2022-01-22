defmodule App.Schema.Lend do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lends" do
    belongs_to :book, App.Schema.Book
    belongs_to :user, App.Schema.User
    field :copies, :integer
    field :expected_date_return, :date
    field :date_returned, :date
    field :penalty, :integer
    timestamps()
  end

  @allowed_fields [
    :book_id,
    :user_id,
    :copies,
    :expected_date_return,
    :date_returned,
    :penalty
  ]

  @doc false
  def changeset(lend, params \\ %{}) do
    lend
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:book)
  end
end