defmodule NoctuaWeb.SharedViewHelpers do
  @moduledoc """
  Conveniences for formatting names and counts.
  """

  use Phoenix.HTML

  def lessons_count(0) do
    "Nessuna lezione"
  end

  def lessons_count(1) do
    "1 lezione"
  end

  def lessons_count(n) do
    "#{n} lezioni"
  end

  def initials(person) do
    "#{String.at(person.first_name, 0)}#{String.at(person.last_name, 0)}"  
  end

  def full_name(person) do
    "#{person.first_name} #{person.last_name}"
  end

  def full_name_emphasised(person) do
    person.first_name <> " " <> safe_to_string(content_tag :span, person.last_name, class: "text-gray-900 font-medium")
  end


end
