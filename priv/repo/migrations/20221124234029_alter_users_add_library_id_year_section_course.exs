defmodule App.Repo.Migrations.AlterUsersAddLibraryIdYearSectionCourse do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :library_id, :string
      add :year, :string
      add :section, :string
      add :course, :string
    end
  end
end
