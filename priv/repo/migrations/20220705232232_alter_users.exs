defmodule App.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :approve, :boolean, default: true
    end
  end
end
