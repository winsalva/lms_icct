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

  @required_fields [
    :book_id,
    :user_id,
    :copies,
    :expected_date_return
  ]

  @doc false
  def changeset(lend, params \\ %{}) do
    lend
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> assoc_constraint(:book)
    |> validate_change(:expected_date_return, &validate/2)
  end

  defp validate(:expected_date_return, ends_at_date) do
    case Date.compare(ends_at_date, Date.utc_today()) do
      :lt -> [expected_date_return: "Return date cannot be in the past"]
      _ -> []
    end
  end
end