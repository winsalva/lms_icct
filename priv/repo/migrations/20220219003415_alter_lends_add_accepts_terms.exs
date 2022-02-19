defmodule App.Repo.Migrations.AlterLendsAddAcceptsTerms do
  use Ecto.Migration

  def change do
    alter table(:lends) do
      add :accept_term, :boolean, default: false
    end
  end
end
