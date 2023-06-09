defmodule App.Schema.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    belongs_to :admin, App.Schema.Admin
    has_many :lends, App.Schema.Lend
    field :isbn, :string
    field :title, :string
    field :author, :string
    field :category, :string
    field :copies, :integer
    field :lended, :integer, default: 0
    field :available, :integer, default: 0
    field :reserved, :integer, default: 0
    field :lend_duration, :integer
    field :accession_number, :string
    timestamps()
  end

  @allowed_fields [
    :admin_id,
    :isbn,
    :title,
    :author,
    :category,
    :copies,
    :lended,
    :available,
    :reserved,
    :lend_duration,
    :accession_number
  ]

  @doc false
  def changeset(book, params \\ %{}) do
    book
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> assoc_constraint(:admin)
    |> unique_constraint(:isbn)
  end
end