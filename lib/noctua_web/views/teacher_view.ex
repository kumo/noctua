defmodule NoctuaWeb.TeacherView do
  use NoctuaWeb, :view

  def title("show.html", assigns) do
    assigns.teacher.first_name <> " " <> assigns.teacher.last_name
  end

  def title("index.html", _assigns) do
    "Elenco Docenti"
  end

  def title("edit.html", _assigns) do
    "Modifica Docente"
  end

  def title(_action, _assigns), do: "Docente"
end
