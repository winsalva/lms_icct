defmodule App.Schema.Announcement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "announcements" do
    belongs_to :admin, App.Schema.Admin
    field :body, :string
    timestamps()
  end

  @doc false
  def changeset(announcement, params \\ %{}) do
    announcement
    |> cast(params, [:body, :admin_id])
    |> validate_required([:body, :admin_id])
  end
end