defmodule NoctuaWeb.DashboardController do
  use NoctuaWeb, :controller
  alias Noctua.Timetabling
  alias Noctua.Reporting

  def index(conn, _params) do
    # I think it makes sense for the Timetabling context to list today's lessons
    lessons = Timetabling.list_today_lessons()
    students = Reporting.list_students_today_stats()
    teachers = Reporting.list_teachers_today_stats()
    render(conn, "index.html", lessons: lessons, students: students, teachers: teachers)
  end
end
