defmodule App.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :admin_id, references(:admins, on_delete: :nothing), null: false
      add :title, :string
      add :thumbnail, :string
      add :body, :text
      timestamps()
    end

    create unique_index(:blogs, [:title])
  end
end
