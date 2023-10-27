defmodule Noctua.Timetabling.Subject do
  use Ecto.Schema
  import Ecto.Changeset

  alias Noctua.Timetabling.Classroom

  schema "subjects" do
    field :name, :string

    has_many :classrooms, Classroom

    timestamps()
  end

  @doc false
  def changeset(subject, attrs) do
    subject
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
