defmodule Noctua.Timetabling.Lesson do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "lessons" do
    field :ended_at, :naive_datetime # I wonder if when is more suitable? I could just do time for start and end
    field :note, :string
    field :started_at, :naive_datetime
    belongs_to :teacher, Noctua.Teaching.Teacher
    belongs_to :student, Noctua.Enroling.Student

    timestamps()
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:started_at, :ended_at, :note, :student_id, :teacher_id])
    |> validate_required([:started_at, :ended_at, :student_id, :teacher_id])
  end

  def ordered(query) do
    from c in query, order_by: c.started_at
  end
end
