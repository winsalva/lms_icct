defmodule AppWeb.PageController do
  use AppWeb, :controller

  alias App.Query.Item
  
  def index(conn, _params) do
    items = Item.list_items
    render(conn, :index, items: items)
  end
end