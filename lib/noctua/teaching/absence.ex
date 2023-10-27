defmodule Noctua.Timetabling.Absence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Noctua.Timetabling.Classroom
  alias Noctua.Enroling.Student

  schema "absences" do
    belongs_to :student, Student
    belongs_to :classroom, Classroom

    field :late, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(absence, attrs) do
    absence
    |> cast(attrs, [:student_id, :classroom_id])
    |> validate_required([:student_id, :classroom_id])
  end
end

