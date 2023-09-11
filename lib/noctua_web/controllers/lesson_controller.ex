defmodule NoctuaWeb.LessonController do
  use NoctuaWeb, :controller

  alias Noctua.Timetabling
  alias Noctua.Timetabling.Lesson

  require Logger

  def index(conn, _params) do
    lessons = Timetabling.list_ordered_lessons()
    render(conn, "index.html", lessons: lessons)
  end

  def new(conn, _params) do
    lesson = %Lesson{started_at: DateTime.utc_now()}
    changeset = Timetabling.change_lesson(lesson)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"lesson" => lesson_params}) do
    case Timetabling.create_lesson(lesson_params) do
      {:ok, _lesson} ->
        conn
        |> put_flash(:info, "Lesson created successfully.")
        |> redirect(to: Routes.lesson_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lesson = Timetabling.get_lesson_with_users!(id)
    render(conn, "show.html", lesson: lesson)
  end

  def edit(conn, %{"id" => id}) do
    lesson = Timetabling.get_lesson!(id)
    changeset = Timetabling.change_lesson(lesson)
    render(conn, "edit.html", lesson: lesson, changeset: changeset)
  end

  def update(conn, %{"id" => id, "lesson" => lesson_params}) do
    lesson = Timetabling.get_lesson!(id)

    case Timetabling.update_lesson(lesson, lesson_params) do
      {:ok, lesson} ->
        conn
        |> put_flash(:info, "Lesson updated successfully.")
        |> redirect(to: Routes.lesson_path(conn, :show, lesson))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", lesson: lesson, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lesson = Timetabling.get_lesson!(id)
    {:ok, _lesson} = Timetabling.delete_lesson(lesson)

    conn
    |> put_flash(:info, "Lesson deleted successfully.")
    |> redirect(to: Routes.lesson_path(conn, :index))
  end
end
