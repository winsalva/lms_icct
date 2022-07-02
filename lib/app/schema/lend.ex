defmodule App.Schema.Lend do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lends" do
    belongs_to :book, App.Schema.Book
    belongs_to :user, App.Schema.User
    field :copies, :integer
    field :release_date, :date
    field :date_returned, :date
    field :penalty, :integer
    field :accept_term, :boolean, default: false
    field :pick_up_date, :date
    field :status, :string
    field :return_condition, :string
    timestamps()
  end

  @allowed_fields [
    :book_id,
    :user_id,
    :date_returned,
    :penalty,
    :accept_term,
    :release_date,
    :pick_up_date,
    :status,
    :return_condition
  ]

  @required_fields [
    :book_id,
    :user_id,
    :accept_term,
    :pick_up_date,
    :status
  ]

  @doc false
  def changeset(lend, params \\ %{}) do
    lend
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:book)
    |> validate_acceptance(:accept_term, message: "Please accept terms and conditions")
  end

  defp validate_accept_term(:accept_term, term_accepted) do
    case term_accepted do
      false -> [accept_term: "You must accept terms and conditions"]
      _ -> []
    end
  end
  

  defp validate(:expected_date_return, ends_at_date) do
    case Date.compare(ends_at_date, Date.utc_today()) do
      :lt -> [expected_date_return: "Return date cannot be in the past"]
      _ -> []
    end
  end
end