defmodule Noctua.Enroling.Student do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "students" do
    field :first_name, :string
    field :last_name, :string

    has_many :lessons, Noctua.Timetabling.Lesson

    field :today_count, :integer, virtual: true
    field :this_week_count, :integer, virtual: true
    field :this_month_count, :integer, virtual: true

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
    from q in query,
      left_join: ltd in subquery(lesson_count_today()), on: ltd.student_id == q.id,
      left_join: ltw in subquery(lesson_count_this_week()), on: ltw.student_id == q.id,
      left_join: ltm in subquery(lesson_count_this_month()), on: ltm.student_id == q.id,
      select_merge: %{today_count: ltd.count, this_week_count: ltw.count, this_month_count: ltm.count}
  end

  defp lesson_count_today do
    # today = Timex.now() |> Timex.beginning_of_day()

    # from l in Noctua.Timetabling.Lesson,
    #   group_by: l.student_id,
    #   where: l.started_at >= ^today,
    #   select: %{student_id: l.student_id, count: count(l.id)}

    Noctua.Timetabling.Lesson
    |> group_by(:student_id)
    |> Noctua.Timetabling.Lesson.today()
    |> select([l], %{student_id: l.student_id, count: count(l.id)})      
  end

  defp lesson_count_this_week do
    Noctua.Timetabling.Lesson
    |> group_by(:student_id)
    |> Noctua.Timetabling.Lesson.this_week()
    |> select([l], %{student_id: l.student_id, count: count(l.id)})      
  end

  defp lesson_count_this_month do
    Noctua.Timetabling.Lesson
    |> group_by(:student_id)
    |> Noctua.Timetabling.Lesson.this_month()
    |> select([l], %{student_id: l.student_id, count: count(l.id)})
  end

end
