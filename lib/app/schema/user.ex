defmodule App.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_many :items, App.Schema.Item
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :seen, :boolean, default: false
    timestamps([type: :utc_datetime_usec])
  end


  @allowed_fields [
    :first_name,
    :middle_name,
    :last_name,
    :phone_number,
    :hashed_password,
    :seen
  ]

  @required_fields [
    :first_name,
    :middle_name,
    :last_name,
    :phone_number,
    :hashed_password,
    :seen
  ]

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_length(:phone_number, min: 11)
    |> unique_constraint(:phone_number)
  end

  @doc false
  def changeset_with_password(user, params \\ %{}) do
    user
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 8)
    |> validate_length(:password, max: 20)
    |> validate_confirmation(:password, required: true)
    |> hash_password()
    |> changeset(params)
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:hashed_password, App.Password.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end