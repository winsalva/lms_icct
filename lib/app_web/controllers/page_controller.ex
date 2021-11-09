defmodule AppWeb.PageController do
  use AppWeb, :controller

  alias App.Query.Upload
  
  def index(conn, _params) do
    uploads = Upload.list_uploads
    render(conn, :index, uploads: uploads)
  end
end