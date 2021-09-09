defmodule NoctuaWeb.StudentView do
  use NoctuaWeb, :view

  def initials(student) do
    "#{String.at(student.first_name, 0)}#{String.at(student.last_name, 0)}"  
  end

  def title("show.html", assigns) do
    assigns.student.first_name <> " " <> assigns.student.last_name
  end

  def title("index.html", _assigns) do
    "Elenco Studenti"
  end

  def title("edit.html", _assigns) do
    "Modifica Studente"
  end

  def title(_action, _assigns), do: "Studente"
end
