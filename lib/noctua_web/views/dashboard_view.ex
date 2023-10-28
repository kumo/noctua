defmodule NoctuaWeb.DashboardView do
  use NoctuaWeb, :view

  def title("index.html", _assigns) do
    "Dashboard"
  end

  def title("parents.html", assigns) do
    "Assenze di " <> assigns.student.first_name <> " " <> assigns.student.last_name
  end
end
