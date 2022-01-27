defmodule App.Repo.Migrations.AlterBooksAddAvailable do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :available, :integer, default: 0
    end
  end
end
