defmodule Noctua.Teaching.Skill do
  use Ecto.Schema
  import Ecto.Changeset
  alias Noctua.Timetabling.Subject
  alias Noctua.Teaching.Teacher

  schema "skills" do
    belongs_to :teacher, Teacher
    belongs_to :subject, Subject

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:teacher_id, :subject_id])
    |> validate_required([:teacher_id, :subject_id])
  end
end
