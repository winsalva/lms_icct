defmodule App.Repo.Migrations.CreateLends do
  use Ecto.Migration

  def change do
    create table(:lends) do
      add :book_id, references(:books, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :copies, :integer
      add :expected_date_return, :date
      add :date_returned, :date
      add :penalty, :integer
      timestamps()
    end
  end
end
