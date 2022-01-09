defmodule App.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :upload_id, references(:uploads, on_delete: :delete_all), null: false
      add :date, :date
      add :no_of_guests, :integer
      timestamps()
    end
  end
end
