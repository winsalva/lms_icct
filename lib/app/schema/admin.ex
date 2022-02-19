defmodule App.Schema.Admin do
  use Ecto.Schema
  import Ecto.Changeset


  schema "admins" do
    has_many :books, App.Schema.Book
    has_one :announcements, App.Schema.Announcement
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
    :hashed_password,
    :super_admin
  ]

  @doc false
  def changeset(admin, params \\ %{}) do
    admin
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @doc false
  def changeset_with_password(admin, params \\ %{}) do
    admin
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