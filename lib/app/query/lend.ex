defmodule App.Query.Lend do

  alias App.Repo
  alias App.Schema.Lend

  def new_lend do
    %Lend{}
    |> Lend.changeset()
  end

  def insert_lend(params) do
    %Lend{}
    |> Lend.changeset(params)
    |> Repo.insert()
  end

  def list_lends do
    Repo.all(Lend)
  end
end