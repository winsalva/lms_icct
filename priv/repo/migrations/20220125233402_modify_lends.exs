defmodule App.Repo.Migrations.ModifyLends do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      remove :book_id, references(:books, on_delete: :nothing), null: false
    end
  end
end
