defmodule App.Repo.Migrations.AltersBooksAddReserved do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :reserved, :integer, default: 0
    end
  end
end
