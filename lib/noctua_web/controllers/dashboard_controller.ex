defmodule NoctuaWeb.DashboardController do
  use NoctuaWeb, :controller
  alias Noctua.Timetabling
  alias Noctua.Reporting
  alias Noctua.Enroling
  alias Noctua.Enroling.Student

  def index(conn, _params) do
    # I think it makes sense for the Timetabling context to list today's lessons
    lessons = Timetabling.list_today_lessons()
    students = Reporting.list_students_today_stats()
    teachers = Reporting.list_teachers_today_stats()
    render(conn, "index.html", lessons: lessons, students: students, teachers: teachers)
  end

  def parents(conn, _params) do
    # I think it makes sense for the Timetabling context to list today's lessons
    student = Enroling.get_student!(1)
    # lessons = Noctua.Timetabling.list_this_month_absent_lessons(student)
    classrooms = Noctua.Timetabling.list_this_month_classrooms(student)
      # lessons = Timetabling.list_today_lessons()
    # students = Reporting.list_students_today_stats()
    # teachers = Reporting.list_teachers_today_stats()
    render(conn, "parents.html", classrooms: classrooms, student: student)
  end
end
