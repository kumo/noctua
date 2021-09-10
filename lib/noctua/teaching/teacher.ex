defmodule Noctua.Teaching.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Noctua.Timetabling.Lesson

  schema "teachers" do
    field :first_name, :string
    field :last_name, :string

    has_many :lessons, Lesson

    field :today_count, :integer, virtual: true
    field :this_week_count, :integer, virtual: true
    field :this_month_count, :integer, virtual: true
    field :last_month_count, :integer, virtual: true
    field :absence_count, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end

  def alphabetical(query) do
    from c in query, order_by: c.last_name
  end

  def with_recent_lessons_count(query) do
    today_query = Lesson |> Lesson.count_for_teachers() |> Lesson.today()
    this_week_query = Lesson |> Lesson.count_for_teachers() |> Lesson.this_week()
    this_month_query = Lesson |> Lesson.count_for_teachers() |> Lesson.this_month()
    last_month_query = Lesson |> Lesson.count_for_teachers() |> Lesson.last_month()

    from q in query,
      left_join: ltd in subquery(today_query), on: ltd.teacher_id == q.id,
      left_join: ltw in subquery(this_week_query), on: ltw.teacher_id == q.id,
      left_join: ltm in subquery(this_month_query), on: ltm.teacher_id == q.id,
      left_join: llm in subquery(last_month_query), on: llm.teacher_id == q.id,
      select_merge: %{today_count: ltd.count, this_week_count: ltw.count, this_month_count: ltm.count, last_month_count: llm.count}
  end

  def with_today_lessons_count(query) do
    today_query = Lesson |> Lesson.count_for_teachers() |> Lesson.today()

    from q in query,
      join: ltd in subquery(today_query), on: ltd.teacher_id == q.id,
      select_merge: %{today_count: ltd.count}
  end

  def with_this_month_lessons_count(query, %Noctua.Enroling.Student{} = student) do
    this_month_query = Lesson |> Lesson.count_for_teachers() |> where([l], l.student_id == ^student.id) |> Lesson.this_month()

    from q in query,
      join: ltd in subquery(this_month_query), on: ltd.teacher_id == q.id,
      select_merge: %{this_month_count: ltd.count}
  end

  def with_this_month_lessons_absences_count(query, %Noctua.Enroling.Student{} = student) do
    this_month_lessons_query = Lesson |> Lesson.count_for_teachers() |> Lesson.present() |> where([l], l.student_id == ^student.id) |> Lesson.this_month()
    this_month_absences_query = Lesson |> Lesson.count_for_teachers() |> Lesson.absent() |> where([l], l.student_id == ^student.id) |> Lesson.this_month()

    from q in query,
      left_join: ltm in subquery(this_month_lessons_query), on: ltm.teacher_id == q.id,
      left_join: atm in subquery(this_month_absences_query), on: atm.teacher_id == q.id,
      select_merge: %{this_month_count: ltm.count, absence_count: atm.count}
  end
end
