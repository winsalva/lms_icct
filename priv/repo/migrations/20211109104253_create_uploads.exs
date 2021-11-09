defmodule App.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :admin_id, references(:admins, on_delete: :nothing), null: false
      add :title, :string
      add :description, :text
      add :file1, :string
      timestamps()
    end
  end
end
