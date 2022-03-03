defmodule App.Repo.Migrations.AlterLendsAddApprove do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      add :status, :string
    end
  end
end
