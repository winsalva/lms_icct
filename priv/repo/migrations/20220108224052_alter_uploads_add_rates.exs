defmodule App.Repo.Migrations.AlterUploadsAddRates do
  use Ecto.Migration

  def change do
    alter table(:uploads) do
      add :rates, :integer
    end
  end
end
