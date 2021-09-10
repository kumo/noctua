defmodule NoctuaWeb.DashboardView do
  use NoctuaWeb, :view

  def title("index.html", _assigns) do
    "Dashboard"
  end

  def format_lesson(0) do
    "Nessuna lezione"
  end

  def format_lesson(1) do
    "1 lezione"
  end

  def format_lesson(n) do
    "#{n} lezioni"
  end
end
