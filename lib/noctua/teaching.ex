defmodule Noctua.Teaching do
  @moduledoc """
  The Teaching context.
  """

  import Ecto.Query, warn: false
  alias Noctua.Repo

  alias Noctua.Teaching.Teacher

  @doc """
  Returns the list of teachers.

  ## Examples

      iex> list_teachers()
      [%Teacher{}, ...]

  """
  def list_teachers do
    Repo.all(Teacher)
  end

  def list_alphabetical_teachers do
    Teacher
    |> Teacher.alphabetical()
    |> Repo.all()
  end

  def list_teachers_with_recent_lessons_count do
    Teacher
    |> Teacher.with_recent_lessons_count()
    |> Teacher.alphabetical()
    |> Repo.all()
  end

  def list_teachers_with_today_lessons_count do
    Teacher
    |> Teacher.with_today_lessons_count()
    |> Teacher.alphabetical()
    |> Repo.all()
  end

  def list_teachers_with_this_month_lessons_count(%Noctua.Enroling.Student{} = student) do
    Teacher
    |> Teacher.with_this_month_lessons_count(student)
    |> Teacher.alphabetical()
    |> Repo.all()
  end

  @doc """
  Gets a single teacher.

  Raises `Ecto.NoResultsError` if the Teacher does not exist.

  ## Examples

      iex> get_teacher!(123)
      %Teacher{}

      iex> get_teacher!(456)
      ** (Ecto.NoResultsError)

  """
  def get_teacher!(id), do: Repo.get!(Teacher, id)

  @doc """
  Creates a teacher.

  ## Examples

      iex> create_teacher(%{field: value})
      {:ok, %Teacher{}}

      iex> create_teacher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_teacher(attrs \\ %{}) do
    %Teacher{}
    |> Teacher.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a teacher.

  ## Examples

      iex> update_teacher(teacher, %{field: new_value})
      {:ok, %Teacher{}}

      iex> update_teacher(teacher, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_teacher(%Teacher{} = teacher, attrs) do
    teacher
    |> Teacher.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a teacher.

  ## Examples

      iex> delete_teacher(teacher)
      {:ok, %Teacher{}}

      iex> delete_teacher(teacher)
      {:error, %Ecto.Changeset{}}

  """
  def delete_teacher(%Teacher{} = teacher) do
    Repo.delete(teacher)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking teacher changes.

  ## Examples

      iex> change_teacher(teacher)
      %Ecto.Changeset{data: %Teacher{}}

  """
  def change_teacher(%Teacher{} = teacher, attrs \\ %{}) do
    Teacher.changeset(teacher, attrs)
  end
end
