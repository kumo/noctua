defmodule Noctua.Parenting.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Noctua.Parenting.Parent
  alias Noctua.Enroling.Student

  schema "permissions" do
    belongs_to :student, Student
    belongs_to :parent, Parent

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:student_id, :parent_id])
    |> validate_required([:student_id, :parent_id])
  end
end
