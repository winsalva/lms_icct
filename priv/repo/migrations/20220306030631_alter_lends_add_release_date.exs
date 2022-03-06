defmodule App.Repo.Migrations.AlterLendsAddReleaseDate do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      remove :expected_date_return, :date
      remove :pickup_date, :string
      add :release_date, :date
      add :pick_up_date, :date
    end
  end
end
