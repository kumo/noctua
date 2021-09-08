defmodule Noctua.Enroling.Student do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "students" do
    field :first_name, :string
    field :last_name, :string

    has_many :lessons, Noctua.Timetabling.Lesson

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
end
