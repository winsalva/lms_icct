defmodule App.Repo.Migrations.AlterUserAddSeenApproval do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :seen_approval, :boolean, default: false
    end
  end
end
