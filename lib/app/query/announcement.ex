defmodule App.Query.Announcement do
  @moduledoc """
  Documentation for Annoucement Context
  """

  alias App.Repo
  alias App.Schema.Announcement

  def new_announcement do
    %Announcement{}
    |> Announcement.changeset()
  end

  def insert_announcement(params) do
    %Announcement{}
    |> Announcement.changeset(params)
    |> Repo.insert()
  end

  def list_announcements do
    query = Repo.all(Announcement)

    if query == [] do
      []
    else
      [announcement|_] = query
      announcement
    end
  end

  def get_announcement(id) do
    Repo.get(Announcement, id)
  end

  def edit_announcement(id) do
    get_announcement(id)
    |> Announcement.changeset()
  end

  def update_announcement(id, params) do
    get_announcement(id)
    |> Announcement.changeset(params)
    |> Repo.update()
  end
end