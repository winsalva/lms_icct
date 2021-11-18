defmodule AppWeb.PageController do
  use AppWeb, :controller

  alias App.Query.Upload
  
  def index(conn, _params) do
    uploads = Upload.list_uploads
    render(conn, :index, uploads: uploads)
  end

  def term_of_use(conn, _params) do
    render(conn, "term-of-use.html")
  end
end