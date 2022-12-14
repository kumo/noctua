defmodule NoctuaWeb.StudentView do
  use NoctuaWeb, :view

  def title("show.html", assigns) do
    assigns.student.first_name <> " " <> assigns.student.last_name
  end

  def title("index.html", _assigns) do
    "Elenco Studenti"
  end

  def title("new.html", _assigns) do
    "Nuovo Studente"
  end

  def title("edit.html", _assigns) do
    "Modifica Studente"
  end

  def title(_action, _assigns), do: "Studenti"
end
