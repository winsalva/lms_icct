defmodule App.Repo.Migrations.AlterUsersAddStudentId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :student_id, :string
    end

    create unique_index(:users, [:student_id])
  end
end
