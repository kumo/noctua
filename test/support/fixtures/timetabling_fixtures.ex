defmodule Noctua.TimetablingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Noctua.Timetabling` context.
  """

  import Noctua.TeachingFixtures
  import Noctua.EnrolingFixtures

  @doc """
  Generate a lesson.
  """
  def lesson_fixture(attrs \\ %{}) do
    student = student_fixture()
    teacher = teacher_fixture()

    {:ok, lesson} =
      attrs
      |> Enum.into(%{
        ended_at: ~N[2021-09-06 12:37:00],
        note: "some note",
        started_at: ~N[2021-09-06 12:37:00],
        student_id: student.id,
        teacher_id: teacher.id
      })
      |> Noctua.Timetabling.create_lesson()

    lesson
  end
end
