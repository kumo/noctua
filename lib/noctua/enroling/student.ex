defmodule Noctua.Enroling.Student do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Noctua.Timetabling.Lesson

  schema "students" do
    field :first_name, :string
    field :last_name, :string

    field :archived, :boolean, default: false

    has_many :lessons, Lesson

    field :today_count, :integer, virtual: true
    field :this_week_count, :integer, virtual: true
    field :this_month_count, :integer, virtual: true
    field :last_month_count, :integer, virtual: true

    field :lesson_count, :integer, virtual: true
    field :absence_count, :integer, virtual: true

    many_to_many :absences, Noctua.Timetabling.Classroom,
      join_through: Noctua.Timetabling.Absence,
      on_delete: :delete_all,
      on_replace: :delete

    many_to_many :parents, Noctua.Parenting.Parent,
      join_through: Noctua.Parenting.Permission,
      on_delete: :delete_all,
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:first_name, :last_name, :archived])
    |> validate_required([:first_name, :last_name])
  end

  def alphabetical(query) do
    from c in query, order_by: c.last_name
  end

  def active(query) do
    from s in query,
      where: is_nil(s.archived) or s.archived != true
  end
end
