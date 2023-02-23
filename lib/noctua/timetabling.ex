defmodule Noctua.Timetabling do
  @moduledoc """
  The Timetabling context.
  """

  import Ecto.Query, warn: false
  alias Noctua.Repo

  alias Noctua.Timetabling.Lesson

  @doc """
  Returns the list of lessons.

  ## Examples

      iex> list_lessons()
      [%Lesson{}, ...]

  """
  def list_lessons do
    Lesson
    |> Repo.all()
    |> Repo.preload(:student)
    |> Repo.preload(:teacher)

    # Repo.all(Lesson), preload: [:student, :teacher])
  end

  def list_ordered_lessons do
    Lesson
    |> Lesson.reverse_ordered()
    |> Repo.all()
    |> Repo.preload(:student)
    |> Repo.preload(:teacher)

    # Repo.all(Lesson), preload: [:student, :teacher])
  end

  def list_today_lessons do
    Lesson
    |> Lesson.ordered()
    |> Lesson.today()
    |> Repo.all()
    |> Repo.preload(:student)
    |> Repo.preload(:teacher)
  end

  def list_today_teachers do
    Lesson
    |> Lesson.ordered()
    |> Lesson.today()
    |> Repo.all()
    |> Repo.preload(:student)
    |> Repo.preload(:teacher)
  end

  def list_this_month_lessons do
    Lesson
    |> Lesson.ordered()
    |> Lesson.this_month()
    |> Repo.all()
    |> Repo.preload(:student)
    |> Repo.preload(:teacher)
  end

  def list_this_month_lessons(%Noctua.Teaching.Teacher{} = teacher) do
    Lesson
    |> Lesson.ordered()
    |> Lesson.this_month()
    |> where([l], l.teacher_id == ^teacher.id)
    |> Repo.all()
    |> Repo.preload(:student)
  end

  def list_this_month_lessons(%Noctua.Enroling.Student{} = student) do
    Lesson
    |> Lesson.ordered()
    |> Lesson.this_month()
    |> where([l], l.student_id == ^student.id)
    |> Repo.all()
    |> Repo.preload(:teacher)
  end

  @doc """
  Gets a single lesson.

  Raises `Ecto.NoResultsError` if the Lesson does not exist.

  ## Examples

      iex> get_lesson!(123)
      %Lesson{}

      iex> get_lesson!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lesson!(id) do
    Lesson
    |> Repo.get(id)
    |> Repo.preload(:student)
    |> Repo.preload(:teacher)
  end

  @doc """
  Creates a lesson.

  ## Examples

      iex> create_lesson(%{field: value})
      {:ok, %Lesson{}}

      iex> create_lesson(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lesson(attrs \\ %{}) do
    %Lesson{teacher_id: 1}
    |> Lesson.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lesson.

  ## Examples

      iex> update_lesson(lesson, %{field: new_value})
      {:ok, %Lesson{}}

      iex> update_lesson(lesson, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lesson(%Lesson{} = lesson, attrs) do
    lesson
    |> Lesson.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lesson.

  ## Examples

      iex> delete_lesson(lesson)
      {:ok, %Lesson{}}

      iex> delete_lesson(lesson)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lesson(%Lesson{} = lesson) do
    Repo.delete(lesson)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lesson changes.

  ## Examples

      iex> change_lesson(lesson)
      %Ecto.Changeset{data: %Lesson{}}

  """
  def change_lesson(%Lesson{} = lesson, attrs \\ %{}) do
    Lesson.changeset(lesson, attrs)
  end
end
