defmodule NoctuaWeb.StudentController do
  use NoctuaWeb, :controller

  alias Noctua.Enroling
  alias Noctua.Enroling.Student

  def index(conn, _params) do
    students = Noctua.Reporting.list_students_recent_stats()
    render(conn, "index.html", students: students)
  end

  def new(conn, _params) do
    changeset = Enroling.change_student(%Student{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"student" => student_params}) do
    case Enroling.create_student(student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student created successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student = Enroling.get_student!(id)
    lessons = Noctua.Timetabling.list_this_month_lessons(student)
    teachers = Noctua.Reporting.list_this_months_teacher_stats_for_student(student)
    # teachers = Noctua.Teaching.list_teachers_month_stats(student)
    render(conn, "show.html", student: student, lessons: lessons, teachers: teachers)
  end

  def edit(conn, %{"id" => id}) do
    student = Enroling.get_student!(id)
    changeset = Enroling.change_student(student)
    render(conn, "edit.html", student: student, changeset: changeset)
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    student = Enroling.get_student!(id)

    case Enroling.update_student(student, student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student updated successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", student: student, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student = Enroling.get_student!(id)
    {:ok, _student} = Enroling.delete_student(student)

    conn
    |> put_flash(:info, "Student deleted successfully.")
    |> redirect(to: Routes.student_path(conn, :index))
  end

  def archive(conn, %{"id" => id}) do
    student = Enroling.get_student!(id)
    {:ok, _student} = Enroling.archive_student(student)

    conn
    |> put_flash(:info, "Student archived successfully.")
    |> redirect(to: Routes.student_path(conn, :index))
  end
  
end
