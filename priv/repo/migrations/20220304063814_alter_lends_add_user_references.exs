defmodule App.Repo.Migrations.AlterLendsAddUserReferences do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      remove :user_id, :integer
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
