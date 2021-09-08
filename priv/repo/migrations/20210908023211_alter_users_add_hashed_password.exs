defmodule Breath.Repo.Migrations.AlterUsersAddHashedPassword do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :hashed_password, :string
    end
    create unique_index(:users, [:phone_number])
  end
end
