defmodule NoctuaWeb.DashboardControllerTest do
  use NoctuaWeb.ConnCase, async: true

  setup :register_and_log_in_user

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Dashboard"
  end
end
