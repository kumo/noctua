defmodule NoctuaWeb.ClassroomController do
  use NoctuaWeb, :controller

  alias Noctua.Timetabling
  alias Noctua.Timetabling.Classroom

  require Logger

  def index(conn, _params) do
    classrooms =
      if conn.assigns.current_user.role == :Teacher do
        Timetabling.list_ordered_classrooms_for_teacher_id(conn.assigns.current_user.teacher.id)
      else
        Timetabling.list_ordered_classrooms()
      end

    render(conn, "index.html", classrooms: classrooms)
  end

  def new(conn, _params) do
    classroom = %Classroom{started_at: DateTime.utc_now()}
    changeset = Timetabling.change_classroom(classroom)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"classroom" => classroom_params}) do
    case Timetabling.create_classroom(classroom_params) do
      {:ok, _classroom} ->
        conn
        |> put_flash(:info, "Classroom created successfully.")
        |> redirect(to: Routes.classroom_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    classroom = Timetabling.get_classroom_with_users!(id)
    render(conn, "show.html", classroom: classroom)
  end

  def edit(conn, %{"id" => id}) do
    classroom = Timetabling.get_classroom!(id)
    changeset = Timetabling.change_classroom(classroom)
    render(conn, "edit.html", classroom: classroom, changeset: changeset)
  end

  def update(conn, %{"id" => id, "classroom" => classroom_params}) do
    classroom = Timetabling.get_classroom!(id)

    case Timetabling.update_classroom(classroom, classroom_params) do
      {:ok, classroom} ->
        conn
        |> put_flash(:info, "Classroom updated successfully.")
        |> redirect(to: Routes.classroom_path(conn, :show, classroom))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", classroom: classroom, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    classroom = Timetabling.get_classroom!(id)
    {:ok, _classroom} = Timetabling.delete_classroom(classroom)

    conn
    |> put_flash(:info, "Classroom deleted successfully.")
    |> redirect(to: Routes.classroom_path(conn, :index))
  end

  def toggle(conn, %{"id" => id, "absence_id" => absence_id}) do
    classroom = Timetabling.get_classroom!(id)
    absence = Timetabling.get_absence!(absence_id)
    Timetabling.toggle_absence(absence)

    conn
    |> put_flash(:info, "Stato aggiornato.")
    |> redirect(to: Routes.classroom_path(conn, :show, classroom))
  end
end
