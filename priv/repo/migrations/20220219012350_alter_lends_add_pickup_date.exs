defmodule App.Repo.Migrations.AlterLendsAddPickupDate do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      add :pickup_date, :string
    end
  end
end
