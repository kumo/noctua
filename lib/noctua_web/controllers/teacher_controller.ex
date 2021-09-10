defmodule NoctuaWeb.TeacherController do
  use NoctuaWeb, :controller

  alias Noctua.Teaching
  alias Noctua.Teaching.Teacher

  def index(conn, _params) do
    teachers = Teaching.list_teachers_with_recent_lessons_count()
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
    lessons = Noctua.Timetabling.list_month_lessons(teacher)
    render(conn, "show.html", teacher: teacher, lessons: lessons)
  end

  def edit(conn, %{"id" => id}) do
    teacher = Teaching.get_teacher!(id)
    changeset = Teaching.change_teacher(teacher)
    render(conn, "edit.html", teacher: teacher, changeset: changeset)
  end

  def update(conn, %{"id" => id, "teacher" => teacher_params}) do
    teacher = Teaching.get_teacher!(id)

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
end
