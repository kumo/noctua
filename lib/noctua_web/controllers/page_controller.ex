defmodule NoctuaWeb.PageController do
  use NoctuaWeb, :controller
  alias Noctua.Timetabling

  def index(conn, _params) do
    lessons = Timetabling.list_today_lessons()
    render(conn, "index.html", lessons: lessons)
  end
end
