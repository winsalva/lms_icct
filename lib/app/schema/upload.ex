defmodule App.Schema.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  alias App.Schema.Admin

  schema "uploads" do
    belongs_to :admin, Admin
    field :category, :string
    field :title, :string
    field :description, :string
    field :file1, :string
    field :file2, :string
    field :file3, :string
    field :file4, :string
    field :files, {:array, :string}
    timestamps()
  end

  @allowed_fields [
    :admin_id,
    :category,
    :title,
    :description,
    :file1,
    :file2,
    :file3,
    :file4,
    :files
  ]

  @required_fields [
    :admin_id,
    :category,
    :title,
    :description,
    :file1
  ]

  @doc false
  def changeset(upload, params \\ %{}) do
    upload
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:admin)
  end
end

