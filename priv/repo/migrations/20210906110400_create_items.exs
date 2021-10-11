defmodule App.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :title, :string
      add :description, :text
      timestamps(type: :utc_datetime_usec)
    end
  end
end
