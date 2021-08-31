defmodule Breath.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :phone_number, :string
      add :seen, :boolean, default: false
      timestamps([type: :utc_datetime_usec])
    end
  end
end
