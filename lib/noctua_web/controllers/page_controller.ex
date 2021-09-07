defmodule NoctuaWeb.PageController do
  use NoctuaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
