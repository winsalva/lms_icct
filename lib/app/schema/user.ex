defmodule App.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :student_id, :string
    field :library_id, :string
    field :year, :string
    field :section, :string
    field :course, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :seen, :boolean, default: false
    field :approve, :boolean, default: false
    field :seen_approval, :boolean, default: false
    timestamps([type: :utc_datetime_usec])
  end


  @allowed_fields [
    :first_name,
    :last_name,
    :student_id,
    :library_id,
    :year,
    :section,
    :course,
    :email,
    :hashed_password,
    :seen,
    :approve,
    :seen_approval
  ]

  @required_fields [
    :first_name,
    :last_name,
    :student_id,
    :library_id,
    :year,
    :section,
    :course,
    :email,
    :hashed_password,
    :seen,
    :approve,
    :seen_approval
  ]

  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/)
    |> unique_constraint(:email)
    |> unique_constraint(:student_id)
  end

  @doc false
  def changeset_with_password(user, params \\ %{}) do
    user
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6)
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