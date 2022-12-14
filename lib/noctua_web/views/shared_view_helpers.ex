defmodule NoctuaWeb.SharedViewHelpers do
  @moduledoc """
  Conveniences for formatting names and counts.
  """

  use Phoenix.HTML

  def lessons_count(n)  when n == 0 or is_nil(n) do
    ""
  end

  def lessons_count(1) do
    "1 lezione"
  end

  def lessons_count(n) do
    "#{n} lezioni"
  end

  def absents_count(nil) do
    ""
  end

  def absents_count(0) do
    ""
  end

  def absents_count(1) do
    "1 assenza"
  end

  def absents_count(n) do
    "#{n} assenze"
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

  def lesson_status(%Noctua.Timetabling.Lesson{absent: true} = lesson) do
    safe_to_string(content_tag :span, "Assente", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800")
  end

  def lesson_status(%Noctua.Timetabling.Lesson{late_minutes: minutes}) when minutes > 0 and is_number(minutes) do
    safe_to_string(content_tag :span, "Ritardo", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800")
  end

  def lesson_status(%Noctua.Timetabling.Lesson{left_early_minutes: minutes}) when minutes > 0 and is_number(minutes)  do
    safe_to_string(content_tag :span, "Anticipato", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800")
  end

  def lesson_status(%Noctua.Timetabling.Lesson{} = lesson) do
    ""
  end

end
