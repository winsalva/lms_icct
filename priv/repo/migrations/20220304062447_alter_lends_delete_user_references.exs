defmodule App.Repo.Migrations.AlterLendsDeleteUserReferences do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      remove :user_id, references(:users, on_delete: :nothing), null: false
      add :user_id, :integer
    end
  end
end
