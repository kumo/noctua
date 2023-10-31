defmodule NoctuaWeb.TeacherController do
  use NoctuaWeb, :controller

  alias Noctua.Teaching
  alias Noctua.Teaching.Teacher

  def index(conn, _params) do
    teachers = Noctua.Reporting.list_teachers_recent_stats()
    render(conn, "index.html", teachers: teachers)
  end

  def new(conn, _params) do
    changeset = Teaching.change_teacher(%Teacher{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"teacher" => teacher_params}) do
    case Teaching.create_teacher(teacher_params) do
      {:ok, teacher} ->
        conn
        |> put_flash(:info, "Teacher created successfully.")
        |> redirect(to: Routes.teacher_path(conn, :show, teacher))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    teacher = Teaching.get_teacher!(id)
    lessons = Noctua.Timetabling.list_this_month_lessons(teacher)
    students = Noctua.Reporting.list_this_months_student_stats_for_teacher(teacher)
    render(conn, "show.html", teacher: teacher, lessons: lessons, students: students)
  end

  def edit(conn, %{"id" => id}) do
    teacher = Teaching.get_teacher_with_user!(id)
    changeset = Teaching.change_teacher(teacher)
    render(conn, "edit.html", teacher: teacher, changeset: changeset)
  end

  def update(conn, %{"id" => id, "teacher" => teacher_params}) do
    teacher = Teaching.get_teacher_with_user!(id)

    case Teaching.update_teacher(teacher, teacher_params) do
      {:ok, teacher} ->
        conn
        |> put_flash(:info, "Teacher updated successfully.")
        |> redirect(to: Routes.teacher_path(conn, :show, teacher))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", teacher: teacher, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    teacher = Teaching.get_teacher!(id)
    {:ok, _teacher} = Teaching.delete_teacher(teacher)

    conn
    |> put_flash(:info, "Teacher deleted successfully.")
    |> redirect(to: Routes.teacher_path(conn, :index))
  end

  def archive(conn, %{"id" => id}) do
    teacher = Teaching.get_teacher!(id)
    {:ok, _teacher} = Teaching.archive_teacher(teacher)

    conn
    |> put_flash(:info, "teacher archived successfully.")
    |> redirect(to: Routes.teacher_path(conn, :index))
  end

end
