defmodule Breath.Schema.Admin do
  use Ecto.Schema
  import Ecto.Changeset


  schema "admins" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :super_admin, :boolean, default: false
    timestamps()
  end

  @allowed_fields [
    :username,
    :email,
    :password,
    :hashed_password,
    :super_admin
  ]

  @doc false
  def changeset(admin, params \\ %{}) do
    admin
    |> cast(params, @allowed_fields)
  end
end