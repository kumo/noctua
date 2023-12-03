defmodule NoctuaWeb.DashboardController do
  use NoctuaWeb, :controller
  alias Noctua.Timetabling
  alias Noctua.Reporting
  alias Noctua.Enroling
  alias Noctua.Enroling.Student

  require Logger

  def index(conn, params) do
    # check type of current user and show a different page for parents
    if conn.assigns.current_user.role == :Parent do
      parents(conn, params)
    else
    # I think it makes sense for the Timetabling context to list today's lessons
    lessons = Timetabling.list_today_lessons()
    students = Reporting.list_students_today_stats()
    teachers = Reporting.list_teachers_today_stats()
    render(conn, "index.html", lessons: lessons, students: students, teachers: teachers)
    end
  end

  def parents(conn, _params) do
    # I think it makes sense for the Timetabling context to list today's lessons
    parent = conn.assigns.current_user.parent
    parent = Noctua.Parenting.get_parent_with_user!(parent.id)
    # get first student of parent permissions
    # students = Noctua.Parenting.get_students_for_parent(parent)

    Logger.error parent.students
    student = parent.students |> Enum.at(0, :no_student)

    # if there are no students, set classrooms as empty array
    classrooms =
      case student do
        :no_student -> []
        _ -> Noctua.Timetabling.list_this_month_classrooms(student)
      end

    render(conn, "parents.html", classrooms: classrooms, student: student)
  end
end
