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
    Teacher
    |> preload([:subjects])
    |> Repo.all()
  end

  def list_alphabetical_teachers do
    Teacher
    |> Teacher.alphabetical()
    |> Teacher.active()
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
  def get_teacher!(id) do
    Teacher
    |> Repo.get!(id)
    |> Repo.preload(:subjects)
    |> with_subject_list()

    # |> Repo.preload(:user)
  end

  def with_subject_list(teacher) do
    subjects =
      teacher.subjects
      |> Enum.map(&"#{&1.id}")

    %Teacher{teacher | subject_list: subjects}
  end

  def get_teacher_with_user!(id) do
    Teacher
    |> Repo.get!(id)
    |> Repo.preload(:user)
    |> Repo.preload(:subjects)
    |> with_subject_list()
  end

  def get_teachers(ids) do
    query = from t in Teacher, where: t.id in ^ids

    teachers = Repo.all(query)
    teachers
  end

  @doc """
  Creates a teacher. And creates a new user too.

  ## Examples

      iex> create_teacher(%{field: value})
      {:ok, %Teacher{}}

      iex> create_teacher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_teacher(attrs \\ %{}) do
    %Teacher{}
    |> Teacher.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:user, with: &Noctua.Accounts.User.changeset_for_teacher/2)
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
  Archives a teacher.

  ## Examples

      iex> archive_teacher(teacher)
      {:ok, %Teacher{}}

      iex> archive_teacher(teacher)
      {:error, %Ecto.Changeset{}}

  """
  def archive_teacher(%Teacher{} = teacher) do
    update_teacher(teacher, %{archived: true})
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
