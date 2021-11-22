defmodule App.Util.Faq do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faqs" do
    field :content, :string
    field :title, :string
    belongs_to :admin, App.Schema.Admin

    timestamps()
  end

  @doc false
  def changeset(faq, attrs \\ %{}) do
    faq
    |> cast(attrs, [:title, :content, :admin_id])
    |> validate_required([:title, :content, :admin_id])
  end
end
