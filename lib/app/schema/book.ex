defmodule App.Schema.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    belongs_to :admin, App.Schema.Admin
    field :isbn, :string
    field :title, :string
    field :author, :string
    field :category, :string
    field :copies, :integer
    field :lended, :integer, default: 0
    timestamps()
  end

  @allowed_fields [
    :admin_id,
    :isbn,
    :title,
    :author,
    :category,
    :copies,
    :lended
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