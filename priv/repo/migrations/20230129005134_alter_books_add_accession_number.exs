defmodule App.Repo.Migrations.AlterBooksAddAccessionNumber do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :accession_number, :string
    end
  end
end
