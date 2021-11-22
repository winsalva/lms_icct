defmodule App.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs) do
      add :title, :string
      add :content, :text
      add :admin_id, references(:admins, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:faqs, [:admin_id])
    create unique_index(:faqs, [:title])
  end
end
