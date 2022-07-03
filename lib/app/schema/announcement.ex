defmodule App.Schema.Announcement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "announcements" do
    belongs_to :admin, App.Schema.Admin
    field :body, :string
    field :hide_date, :date
    timestamps()
  end

  @doc false
  def changeset(announcement, params \\ %{}) do
    announcement
    |> cast(params, [:body, :admin_id, :hide_date])
    |> validate_required([:body, :admin_id, :hide_date])
  end
end