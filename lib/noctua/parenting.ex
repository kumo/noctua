defmodule Noctua.Parenting do
  @moduledoc """
  The Parenting context.
  """

  import Ecto.Query, warn: false
  alias Noctua.Repo

  alias Noctua.Parenting.Parent

  @doc """
  Returns the list of parents.

  ## Examples

      iex> list_parents()
      [%Parent{}, ...]

  """
  def list_parents do
    Repo.all(Parent)
  end

  def list_alphabetical_parents do
    Parent
    |> Parent.alphabetical()
    |> Parent.active()
    |> Repo.all()
    |> Repo.preload(:students)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single parent.

  Raises `Ecto.NoResultsError` if the Parent does not exist.

  ## Examples

      iex> get_parent!(123)
      %Parent{}

      iex> get_parent!(456)
      ** (Ecto.NoResultsError)

  """
  def get_parent!(id) do
    Parent
    |> Repo.get!(id)
    |> Repo.preload(:students)
    |> with_student_list()
  end

  def with_student_list(%Parent{} = parent) do
    students =
      parent.students
      |> Enum.map(&"#{&1.id}")

    %Parent{parent | student_list: students}
  end

  def get_parent_with_user!(id) do
    Parent
    |> Repo.get!(id)
    |> Repo.preload(:user)
    |> Repo.preload(:students)
    |> with_student_list()
  end

  def get_students_for_parent(%Noctua.Parenting.Parent{} = parent) do
    Parent
    |> Repo.get!(parent.id)
    |> Repo.preload(:students)

    parent.students

    # Get all students for the parent id
    # Repo.all(from s in Noctua.Enroling.Student, where: s.parent_id == ^parent.id)

    # Get all students for the parent id in the permissions multi-to-multi join
    # Repo.all(from s in Noctua.Enroling.Student, join: p in Noctua.Parenting.Parent, on: s.parent_id == p.id, where: p.id == ^parent.id)
  end

  @doc """
  Creates a parent. And creates a new user too.

  ## Examples

      iex> create_parent(%{field: value})
      {:ok, %Parent{}}

      iex> create_parent(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_parent(attrs \\ %{}) do
    %Parent{}
    |> Parent.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:user, with: &Noctua.Accounts.User.changeset_for_parent/2)
    |> Repo.insert()
  end

  @doc """
  Updates a parent.

  ## Examples

      iex> update_parent(parent, %{field: new_value})
      {:ok, %Parent{}}

      iex> update_parent(parent, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_parent(%Parent{} = parent, attrs) do
    parent
    |> Parent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a parent.

  ## Examples

      iex> delete_parent(parent)
      {:ok, %Parent{}}

      iex> delete_parent(parent)
      {:error, %Ecto.Changeset{}}

  """
  def delete_parent(%Parent{} = parent) do
    Repo.delete(parent)
  end

  @doc """
  Archives a parent.

  ## Examples

      iex> archive_parent(parent)
      {:ok, %Parent{}}

      iex> archive_parent(parent)
      {:error, %Ecto.Changeset{}}

  """
  def archive_parent(%Parent{} = parent) do
    update_parent(parent, %{archived: true})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking parent changes.

  ## Examples

      iex> change_parent(parent)
      %Ecto.Changeset{data: %Parent{}}

  """
  def change_parent(%Parent{} = parent, attrs \\ %{}) do
    Parent.changeset(parent, attrs)
  end
end
