defmodule App.Query.Upload do
  @moduledoc """
  Documentation for Upload.
  """

  alias App.Repo
  alias App.Schema.Upload

  @doc """
  New Upload.
  """
  def new_upload do
    Upload.changeset(%Upload{})
  end

  @doc """
  Insert new upload.
  """
  def insert_upload(params) do
    %Upload{}
    |> Upload.changeset(params)
    |> Repo.insert()
  end

  @doc """
  List uploads.
  """
  def list_uploads do
    Repo.all(Upload)
  end

  @doc """
  Get upload by id.
  """
  def get_upload(id) do
    Repo.get(Upload, id)
  end
end