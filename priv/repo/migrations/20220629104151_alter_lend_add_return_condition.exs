defmodule App.Repo.Migrations.AlterLendAddReturnCondition do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      add :return_condition, :string
    end
  end
end
