defmodule App.Repo.Migrations.AlterBooksAddLendDuration do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :lend_duration, :integer
    end
  end
end
