defmodule Noctua.Timetabling do
  @moduledoc """
  The Timetabling context.
  """

  import Ecto.Query, warn: false
  alias Noctua.Repo

  alias Noctua.Timetabling.Lesson
  alias Noctua.Timetabling.Classroom

  @doc """
  Returns the list of lessons.

  ## Examples

      iex> list_lessons()
      [%Lesson{}, ...]

  """
  def list_lessons do
    Lesson
    |> Repo.all()

    # |> Repo.preload(:student)
    # |> Repo.preload(:teacher)

    # Repo.all(Lesson), preload: [:student, :teacher])
  end

  def list_ordered_lessons_for_teacher_id(teacher_id) do
    query =
      from l in Lesson,
        order_by: [desc: l.started_at],
        join: s in assoc(l, :student),
        join: t in assoc(l, :teacher),
        where: is_nil(s.archived) or s.archived != true,
        where: is_nil(t.archived) or t.archived != true,
        where: l.teacher_id == ^teacher_id,
        preload: [:student, :teacher]

    Repo.all(query)
  end

  def list_ordered_lessons do
    query =
      from l in Lesson,
        order_by: [desc: l.started_at],
        join: s in assoc(l, :student),
        join: t in assoc(l, :teacher),
        where: is_nil(s.archived) or s.archived != true,
        where: is_nil(t.archived) or t.archived != true,
        preload: [:student, :teacher]

    Repo.all(query)
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

  def list_this_month_absent_lessons do
    Lesson
    |> Lesson.ordered()
    |> Lesson.this_month()
    |> where([l], l.absent == true)
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

  def list_this_month_absent_lessons(%Noctua.Enroling.Student{} = student) do
    Lesson
    |> Lesson.ordered()
    |> Lesson.this_month()
    |> where([l], l.student_id == ^student.id)
    |> where([l], l.absent == true or l.late_minutes > 0 or l.left_early_minutes > 0)
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
    |> Repo.get!(id)

    # |> Repo.preload(:student)
    # |> Repo.preload(:teacher)
  end

  def get_lesson_with_users!(id) do
    Lesson
    |> Repo.get!(id)
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

  @doc """
  Returns the list of classrooms.

  ## Examples

      iex> list_classrooms()
      [%Classroom{}, ...]

  """
  def list_classrooms do
    Classroom
    |> Repo.all()
    |> Repo.preload(:subject)
    |> Repo.preload(:students)
    |> Repo.preload(:teacher)

    # |> Repo.preload(:student)
    # |> Repo.preload(:teacher)

    # Repo.all(Classroom), preload: [:student, :teacher])
  end

  def list_ordered_classrooms do
    Classroom
    |> Classroom.reverse_ordered()
    |> Repo.all()
    |> Repo.preload(:teacher)
    |> Repo.preload(:subject)
    |> Repo.preload(:students)

    # Repo.all(Classroom), preload: [:student, :teacher])
  end

  def list_ordered_classrooms_for_teacher_id(teacher_id) do
    query =
      from c in Classroom,
        order_by: [desc: c.started_at],
        join: s in assoc(c, :students),
        join: t in assoc(c, :teacher),
        where: is_nil(s.archived) or s.archived != true,
        where: is_nil(t.archived) or t.archived != true,
        where: c.teacher_id == ^teacher_id,
        preload: [:students, :teacher, :subject]

    Repo.all(query)
  end

  def list_today_classrooms do
    Classroom
    |> Classroom.ordered()
    |> Classroom.today()
    |> Repo.all()
    |> Repo.preload(:teacher)
  end

  # def list_today_teachers do
  #   Classroom
  #   |> Classroom.ordered()
  #   |> Classroom.today()
  #   |> Repo.all()
  #   |> Repo.preload(:student)
  #   |> Repo.preload(:teacher)
  # end

  def list_this_month_classrooms do
    Classroom
    |> Classroom.ordered()
    |> Classroom.this_month()
    |> Repo.all()
    |> Repo.preload(:teacher)
  end

  def list_this_month_absent_classrooms do
    Classroom
    |> Classroom.ordered()
    |> Classroom.this_month()
    |> where([l], l.absent == true)
    |> Repo.all()
    |> Repo.preload(:teacher)
  end

  def list_this_month_classrooms(%Noctua.Teaching.Teacher{} = teacher) do
    Classroom
    |> Classroom.ordered()
    |> Classroom.this_month()
    |> where([l], l.teacher_id == ^teacher.id)
    |> Repo.all()
    |> Repo.preload(:student)
  end

  def list_this_month_classrooms(%Noctua.Enroling.Student{} = student) do
    Repo.all(
      from c in Classroom,
        join: s in assoc(c, :students),
        where: s.id == ^student.id,
        preload: [students: s],
        preload: [:subject]
    )
  end

  def list_this_month_absent_classrooms(%Noctua.Enroling.Student{} = student) do
    Classroom
    |> Classroom.ordered()
    |> Classroom.this_month()
    |> where([c], c.student_id == ^student.id)
    # |> where([l], l.absent == true or l.late_minutes > 0 or l.left_early_minutes > 0)
    |> Repo.all()
    |> Repo.preload(:teacher)
    |> Repo.preload(:absences)
  end

  @doc """
  Gets a single classroom.

  Raises `Ecto.NoResultsError` if the Classroom does not exist.

  ## Examples

      iex> get_classroom!(123)
      %Classroom{}

      iex> get_classroom!(456)
      ** (Ecto.NoResultsError)

  """
  def get_classroom!(id) do
    Classroom
    |> Repo.get!(id)
    |> Repo.preload(:subject)
    |> Repo.preload(:teacher)
    |> Repo.preload(:students)
    |> with_student_list()

    # |> Repo.preload(:student)
    # |> Repo.preload(:teacher)
  end

  def with_student_list(classroom) do
    students =
      classroom.students
      |> Enum.map(&"#{&1.id}")

    %Classroom{classroom | student_list: students}
  end

  def get_classroom_with_users!(id) do
    Classroom
    |> Repo.get!(id)
    |> Repo.preload(:students)
    |> Repo.preload(:teacher)
  end

  @doc """
  Creates a classroom.

  ## Examples

      iex> create_classroom(%{field: value})
      {:ok, %Classroom{}}

      iex> create_classroom(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_classroom(attrs \\ %{}) do
    %Classroom{teacher_id: 1}
    |> Classroom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a classroom.

  ## Examples

      iex> update_classroom(classroom, %{field: new_value})
      {:ok, %Classroom{}}

      iex> update_classroom(classroom, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_classroom(%Classroom{} = classroom, attrs) do
    classroom
    |> Classroom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a classroom.

  ## Examples

      iex> delete_classroom(classroom)
      {:ok, %Classroom{}}

      iex> delete_classroom(classroom)
      {:error, %Ecto.Changeset{}}

  """
  def delete_classroom(%Classroom{} = classroom) do
    Repo.delete(classroom)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking classroom changes.

  ## Examples

      iex> change_classroom(classroom)
      %Ecto.Changeset{data: %Classroom{}}

  """
  def change_classroom(%Classroom{} = classroom, attrs \\ %{}) do
    Classroom.changeset(classroom, attrs)
  end

  alias Noctua.Timetabling.Subject

  @doc """
  Returns the list of subjects.

  ## Examples

      iex> list_subjects()
      [%Subject{}, ...]

  """
  def list_subjects do
    Repo.all(Subject)
  end

  @doc """
  Gets a single subject.

  Raises `Ecto.NoResultsError` if the Subject does not exist.

  ## Examples

      iex> get_subject!(123)
      %Subject{}

      iex> get_subject!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subject!(id) do
    Subject
    |> Repo.get!(id)
    |> Repo.preload(:teachers)
    |> with_teacher_list()
  end

  def with_teacher_list(subject) do
    teachers =
      subject.teachers
      |> Enum.map(&"#{&1.id}")

    %Subject{subject | teacher_list: teachers}
  end

  def get_subjects(ids) do
    query = from s in Subject, where: s.id in ^ids

    subjects = Repo.all(query)
    subjects
  end

  @doc """
  Creates a subject.

  ## Examples

      iex> create_subject(%{field: value})
      {:ok, %Subject{}}

      iex> create_subject(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subject(attrs \\ %{}) do
    %Subject{}
    |> Subject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subject.

  ## Examples

      iex> update_subject(subject, %{field: new_value})
      {:ok, %Subject{}}

      iex> update_subject(subject, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subject(%Subject{} = subject, attrs) do
    subject
    |> Subject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subject.

  ## Examples

      iex> delete_subject(subject)
      {:ok, %Subject{}}

      iex> delete_subject(subject)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subject(%Subject{} = subject) do
    Repo.delete(subject)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subject changes.

  ## Examples

      iex> change_subject(subject)
      %Ecto.Changeset{data: %Subject{}}

  """
  def change_subject(%Subject{} = subject, attrs \\ %{}) do
    Subject.changeset(subject, attrs)
  end
end
