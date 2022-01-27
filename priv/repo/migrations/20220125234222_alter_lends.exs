defmodule App.Repo.Migrations.AlterLends do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      add :book_id, references(:books, on_delete: :delete_all), null: false
    end
  end
end
