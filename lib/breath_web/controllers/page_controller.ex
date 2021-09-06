defmodule BreathWeb.PageController do
  use BreathWeb, :controller

  alias Breath.Query.Item
  
  def index(conn, _params) do
    items = Item.list_items
    render(conn, :index, items: items)
  end
end