defmodule Breath.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :username, :string
      add :email, :string
      add :hashed_password, :string
      add :super_admin, :boolean, default: false
      timestamps()
    end

   create unique_index(:admins, [:email])
  end
end
