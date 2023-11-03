defmodule Noctua.Timetabling.Subject do
  use Ecto.Schema
  import Ecto.Changeset

  alias Noctua.Timetabling.Classroom

  schema "subjects" do
    field :name, :string

    has_many :classrooms, Classroom

    many_to_many :teachers, Noctua.Teaching.Teacher,
      join_through: Noctua.Teaching.Skill,
      on_delete: :delete_all,
      on_replace: :delete

    field(:teacher_list, {:array, :string}, virtual: true, default: [])

    timestamps()
  end

  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(subject, attrs) do
    subject
    |> cast(attrs, [:name])
    |> put_assoc(:teachers, fetch_teachers(attrs))
    |> validate_required([:name])
  end

  defp fetch_teachers(%{teacher_list: ids}),
    do: fetch_teachers(%{"teacher_list" => ids})

  defp fetch_teachers(%{"teacher_list" => teachers_ids}) do
    # Logger.error("fetch teachers")

    teachers =
      teachers_ids
      |> Enum.reject(&(&1 == ""))
      |> Noctua.Teaching.get_teachers()

    # Logger.error(dbg(teachers))
    teachers
  end

  defp fetch_teachers(_), do: []
end
