defmodule Noctua.Enroling do
  @moduledoc """
  The Enroling context.
  """

  import Ecto.Query, warn: false
  alias Noctua.Repo

  alias Noctua.Enroling.Student

  @doc """
  Returns the list of students.

  ## Examples

      iex> list_students()
      [%Student{}, ...]

  """
  def list_students do
    Repo.all(Student)
  end

  def list_alphabetical_students do
    Student
    |> Student.alphabetical()
    |> Student.active()
    |> Repo.all()
  end

  @doc """
  Gets a single student.

  Raises `Ecto.NoResultsError` if the Student does not exist.

  ## Examples

      iex> get_student!(123)
      %Student{}

      iex> get_student!(456)
      ** (Ecto.NoResultsError)

  """
  def get_student!(id) do
    Student
    |> Repo.get!(id)

    # |> Repo.preload(:lessons)
  end

  def get_students(ids) do
    query = from s in Student, where: s.id in ^ids

    students = Repo.all(query)
    students
  end

  @doc """
  Creates a student.

  ## Examples

      iex> create_student(%{field: value})
      {:ok, %Student{}}

      iex> create_student(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_student(attrs \\ %{}) do
    %Student{}
    |> Student.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a student.

  ## Examples

      iex> update_student(student, %{field: new_value})
      {:ok, %Student{}}

      iex> update_student(student, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_student(%Student{} = student, attrs) do
    student
    |> Student.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a student.

  ## Examples

      iex> delete_student(student)
      {:ok, %Student{}}

      iex> delete_student(student)
      {:error, %Ecto.Changeset{}}

  """
  def delete_student(%Student{} = student) do
    Repo.delete(student)
  end

  @doc """
  Archives a student.

  ## Examples

      iex> archive_student(student)
      {:ok, %Student{}}

      iex> archive_student(student)
      {:error, %Ecto.Changeset{}}

  """
  def archive_student(%Student{} = student) do
    update_student(student, %{archived: true})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking student changes.

  ## Examples

      iex> change_student(student)
      %Ecto.Changeset{data: %Student{}}

  """
  def change_student(%Student{} = student, attrs \\ %{}) do
    Student.changeset(student, attrs)
  end
end
