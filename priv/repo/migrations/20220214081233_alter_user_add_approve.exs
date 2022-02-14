defmodule App.Repo.Migrations.AlterUserAddApprove do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :approve, :boolean, default: false
    end
  end
end
