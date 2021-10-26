defmodule Noctua.Reporting do
  @moduledoc """
  The Reporting context.
  """

  import Ecto.Query, warn: false
  alias Noctua.Repo

  alias Noctua.Teaching.Teacher
  alias Noctua.Enroling.Student
  alias Noctua.Timetabling.Lesson

  defp teacher_lessons_query() do
    Lesson |> Lesson.count_for_teachers()
  end

  defp student_lessons_query() do
    Lesson |> Lesson.count_for_students()
  end

  def list_teachers_today_stats do
    partial_query = teacher_lessons_query() |> Lesson.today()

    Teacher
    |> single_stats(partial_query)
    |> Teacher.alphabetical()
    |> Repo.all()
    |> Enum.reject(& is_nil(&1.lesson_count) and is_nil(&1.absence_count))
  end

  def list_this_months_teacher_stats_for_student(%Noctua.Enroling.Student{} = student) do
    partial_query = teacher_lessons_query() |> where([l], l.student_id == ^student.id) |> Lesson.this_month()

    Teacher
    |> all_stats(partial_query)
    |> Teacher.alphabetical()
    |> Repo.all()
    |> Enum.reject(& is_nil(&1.this_month_count) and is_nil(&1.absence_count))
  end

  def list_this_months_student_stats_for_teacher(%Noctua.Teaching.Teacher{} = teacher) do
    partial_query = student_lessons_query() |> where([l], l.teacher_id == ^teacher.id) |> Lesson.this_month()

    Student
    |> all_stats(partial_query)
    |> Student.alphabetical()
    |> Repo.all()
    |> Enum.reject(& is_nil(&1.this_month_count) and is_nil(&1.absence_count))
  end

  def list_students_today_stats do
    partial_query = student_lessons_query() |> Lesson.today()

    Student
    |> single_stats(partial_query)
    |> Student.alphabetical()
    |> Repo.all()
    |> Enum.reject(& is_nil(&1.lesson_count) and is_nil(&1.absence_count))
  end

  def list_students_recent_stats do
    partial_query = student_lessons_query() # no date

    Student
    |> all_stats(partial_query)
    |> Student.alphabetical()
    |> Repo.all()
  end

  def list_teachers_recent_stats do
    partial_query = teacher_lessons_query() # no date

    Teacher
    |> all_stats(partial_query)
    |> Teacher.alphabetical()
    |> Repo.all()
  end

  defp single_stats(query, partial_query) do
    from q in query,
      left_join: pq in subquery(partial_query |> Lesson.present), on: pq.link_id == q.id,
      left_join: aq in subquery(partial_query |> Lesson.absent), on: aq.link_id == q.id,
      select_merge: %{lesson_count: pq.count, absence_count: aq.count}
  end

  defp all_stats(query, partial_query) do
    present_query = partial_query |> Lesson.present
    absent_query = partial_query |> Lesson.absent

    from q in query,
      left_join: tdq in subquery(present_query |> Lesson.today), on: tdq.link_id == q.id,
      left_join: twq in subquery(present_query |> Lesson.this_week), on: twq.link_id == q.id,
      left_join: tmq in subquery(present_query |> Lesson.this_month), on: tmq.link_id == q.id,
      left_join: lmq in subquery(present_query |> Lesson.last_month), on: lmq.link_id == q.id,
      left_join: tmaq in subquery(absent_query |> Lesson.this_month), on: tmaq.link_id == q.id,
      select_merge: %{today_count: tdq.count, this_week_count: twq.count, this_month_count: tmq.count, last_month_count: lmq.count, absence_count: tmaq.count}
  end
end
