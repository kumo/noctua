defmodule Noctua.Enroling.Student do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Noctua.Timetabling.Lesson

  schema "students" do
    field :first_name, :string
    field :last_name, :string

    has_many :lessons, Lesson

    field :today_count, :integer, virtual: true
    field :this_week_count, :integer, virtual: true
    field :this_month_count, :integer, virtual: true
    field :last_month_count, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end

  def alphabetical(query) do
    from c in query, order_by: c.last_name
  end

  def with_recent_lessons_count(query) do
    today_query = Lesson |> Lesson.count_for_students() |> Lesson.today()
    this_week_query = Lesson |> Lesson.count_for_students() |> Lesson.this_week()
    this_month_query = Lesson |> Lesson.count_for_students() |> Lesson.this_month()
    last_month_query = Lesson |> Lesson.count_for_students() |> Lesson.last_month()

    from q in query,
      left_join: ltd in subquery(today_query), on: ltd.student_id == q.id,
      left_join: ltw in subquery(this_week_query), on: ltw.student_id == q.id,
      left_join: ltm in subquery(this_month_query), on: ltm.student_id == q.id,
      left_join: llm in subquery(last_month_query), on: llm.student_id == q.id,
      select_merge: %{today_count: ltd.count, this_week_count: ltw.count, this_month_count: ltm.count, last_month_count: llm.count}
  end

  def with_today_lessons_count(query) do
    today_query = Lesson |> Lesson.count_for_students() |> Lesson.today()

    from q in query,
      join: ltd in subquery(today_query), on: ltd.student_id == q.id,
      select_merge: %{today_count: ltd.count}
  end

  def with_this_month_lessons_count(query, %Noctua.Teaching.Teacher{} = teacher) do
    this_month_query = Lesson |> Lesson.count_for_students() |> where([l], l.teacher_id == ^teacher.id) |> Lesson.this_month()

    from q in query,
      join: ltd in subquery(this_month_query), on: ltd.student_id == q.id,
      select_merge: %{this_month_count: ltd.count}
  end
end
