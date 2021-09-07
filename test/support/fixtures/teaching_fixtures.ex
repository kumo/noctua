defmodule Noctua.TeachingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Noctua.Teaching` context.
  """

  @doc """
  Generate a teacher.
  """
  def teacher_fixture(attrs \\ %{}) do
    {:ok, teacher} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> Noctua.Teaching.create_teacher()

    teacher
  end
end
