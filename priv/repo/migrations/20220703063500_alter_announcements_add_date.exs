defmodule App.Repo.Migrations.AlterAnnouncementsAddDate do
  use Ecto.Migration

  def change do
    alter table(:announcements) do
      add :hide_date, :date
    end
  end
end
