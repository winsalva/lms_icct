defmodule App.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :admin_id, references(:admins, on_delete: :nothing), null: false
      add :isbn, :string
      add :title, :string
      add :author, :string
      add :category, :string
      add :copies, :integer
      add :lended, :integer, default: 0
      timestamps()
    end

    create unique_index(:books, [:isbn])
  end
end
