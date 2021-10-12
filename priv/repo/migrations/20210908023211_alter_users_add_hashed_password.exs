defmodule App.Repo.Migrations.AlterUsersAddHashedPassword do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :hashed_password, :string
    end
  end
end
