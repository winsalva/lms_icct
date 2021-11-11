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

  @doc """
  Edit upload.
  """
  def edit_upload(id) do
    Repo.get(Upload, id)
    |> Upload.changeset()
  end

  @doc """
  Update upload
  """
  def update_upload(id, params) do
    get_upload(id)
    |> Upload.changeset(params)
    |> Repo.update()
  end

  @doc """
  Delete upload
  """
  def delete_upload(id) do
    get_upload(id)
    |> Repo.delete()
  end
end