defmodule NoctuaWeb.ParentView do
  use NoctuaWeb, :view

  def title("show.html", assigns) do
    assigns.parent.first_name <> " " <> assigns.parent.last_name
  end

  def title("index.html", _assigns) do
    "Elenco Genitori"
  end

  def title("new.html", _assigns) do
    "Nuovo Genitore"
  end

  def title("edit.html", _assigns) do
    "Modifica Genitore"
  end

  def title(_action, _assigns), do: "Genitori"
end
