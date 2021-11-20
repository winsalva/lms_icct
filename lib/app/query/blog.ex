defmodule App.Query.Blog do
  @moduledoc """
  Documentation for Blog.
  """

  alias App.Repo
  alias App.Schema.Blog

  @doc """
  New blog.
  """
  def new_blog do
    %Blog{}
    |> Blog.changeset()
  end

  @doc """
  Insert blog.
  """
  def insert_blog(params) do
    %Blog{}
    |> Blog.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Get blog by id.
  """
  def get_blog(id) do
    Repo.get(Blog, id)
  end

  @doc """
  List blogs.
  """
  def list_blogs do
    Repo.all(Blog)
  end

  @doc """
  Get blog for editing.
  """
  def edit_blog(id) do
    get_blog(id)
    |> Blog.changeset()
  end

  @doc """
  Update blog.
  """
  def update_blog(id, params) do
    get_blog(id)
    |> Blog.changeset(params)
    |> Repo.update()
  end

  @doc """
  Delete blog.
  """
  def delete_blog(id) do
    get_blog(id)
    |> Repo.delete()
  end
end