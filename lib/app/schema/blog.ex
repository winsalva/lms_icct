defmodule App.Schema.Blog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blogs" do
    field :title, :string
    field :thumbnail, :string
    field :body, :string
    belongs_to :admin, App.Schema.Admin
    timestamps()
  end

  @allowed_fields ~w(title thumbnail body admin_id)a

  @doc false
  def changeset(blog, params \\ %{}) do
    blog
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> unique_constraint(:title)
    |> assoc_constraint(:admin)
  end
end