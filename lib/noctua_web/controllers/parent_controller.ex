defmodule NoctuaWeb.ParentController do
  use NoctuaWeb, :controller

  alias Noctua.Parenting
  alias Noctua.Parenting.Parent

  def index(conn, _params) do
    parents = Noctua.Parenting.list_alphabetical_parents()
    render(conn, "index.html", parents: parents)
  end

  def new(conn, _params) do
    changeset = Parenting.change_parent(%Parent{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"parent" => parent_params}) do
    case Parenting.create_parent(parent_params) do
      {:ok, parent} ->
        conn
        |> put_flash(:info, "Parent created successfully.")
        |> redirect(to: Routes.parent_path(conn, :show, parent))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    parent = Parenting.get_parent!(id)
    # lessons = Noctua.Timetabling.list_this_month_lessons(parent)
    students = [] # Noctua.Parenting.list_active_students_for_parent(parent)
    lessons = []
    render(conn, "show.html", parent: parent, students: students, lessons: lessons)
  end

  def edit(conn, %{"id" => id}) do
    parent = Parenting.get_parent_with_user!(id)
    changeset = Parenting.change_parent(parent)
    render(conn, "edit.html", parent: parent, changeset: changeset)
  end

  def update(conn, %{"id" => id, "parent" => parent_params}) do
    parent = Parenting.get_parent_with_user!(id)

    case Parenting.update_parent(parent, parent_params) do
      {:ok, parent} ->
        conn
        |> put_flash(:info, "Parent updated successfully.")
        |> redirect(to: Routes.parent_path(conn, :show, parent))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", parent: parent, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    parent = Parenting.get_parent!(id)
    {:ok, _parent} = Parenting.delete_parent(parent)

    conn
    |> put_flash(:info, "Parent deleted successfully.")
    |> redirect(to: Routes.parent_path(conn, :index))
  end

  def archive(conn, %{"id" => id}) do
    parent = Parenting.get_parent!(id)
    {:ok, _parent} = Parenting.archive_parent(parent)

    conn
    |> put_flash(:info, "Parent archived successfully.")
    |> redirect(to: Routes.parent_path(conn, :index))
  end
end
