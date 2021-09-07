defmodule Noctua.Timetabling.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lessons" do
    field :ended_at, :naive_datetime
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
end
