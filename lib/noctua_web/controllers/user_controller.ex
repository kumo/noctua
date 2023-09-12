defmodule NoctuaWeb.UserController do
  use NoctuaWeb, :controller

  def index(conn, _params) do
    users = Noctua.Accounts.list_users()
    render(conn, "index.html", users: users)
  end
end
