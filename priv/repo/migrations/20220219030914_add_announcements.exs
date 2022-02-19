defmodule App.Repo.Migrations.AddAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements) do
      add :admin_id, references(:admins, on_delete: :delete_all), null: false
      add :body, :text
      timestamps()
    end
  end
end
