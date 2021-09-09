defmodule NoctuaWeb.PageController do
  use NoctuaWeb, :controller
  alias Noctua.Timetabling
  alias Noctua.Enroling
  alias Noctua.Teaching

  def index(conn, _params) do
    lessons = Timetabling.list_today_lessons()
    students = Enroling.list_students_with_today_lessons_count()
    teachers = Teaching.list_teachers_with_today_lessons_count()
    render(conn, "index.html", lessons: lessons, students: students, teachers: teachers)
  end
end
