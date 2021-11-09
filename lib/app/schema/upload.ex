defmodule App.Schema.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  alias App.Schema.Admin

  schema "uploads" do
    belongs_to :admin, Admin
    field :title, :string
    field :description, :string
    field :file1, :string
    timestamps()
  end

  @allowed_fields [
    :admin_id,
    :title,
    :description,
    :file1
  ]

  @doc false
  def changeset(upload, params \\ %{}) do
    upload
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> assoc_constraint(:admin)
  end
end

