defmodule Noctua.Parenting.Parent do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Noctua.Teacher.Address

  schema "parents" do
    field :first_name, :string
    field :last_name, :string

    field :archived, :boolean, default: false

    belongs_to :user, Noctua.Accounts.User

    embeds_one :address, Address

    many_to_many :students, Noctua.Enroling.Student,
      join_through: Noctua.Parenting.Permission,
      on_delete: :delete_all,
      on_replace: :delete

    field(:student_list, {:array, :string}, virtual: true, default: [])

    timestamps()
  end

  @doc false
  def changeset(parent, attrs) do
    parent
    |> cast(attrs, [:first_name, :last_name, :archived])
    |> cast_embed(:address)
    |> put_assoc(:students, fetch_students(attrs))
    |> validate_required([:first_name, :last_name])
  end

  def alphabetical(query) do
    from c in query, order_by: c.last_name
  end

  def active(query) do
    from t in query,
      where: is_nil(t.archived) or t.archived != true
  end

  defp fetch_students(%{student_list: ids}),
    do: fetch_students(%{"student_list" => ids})

  defp fetch_students(%{"student_list" => students_ids}) do
    # Logger.error("fetch students")

    students =
      students_ids
      |> Enum.reject(&(&1 == ""))
      |> Noctua.Enroling.get_students()

    # Logger.error(dbg(students))
    students
  end

  defp fetch_students(_), do: []
end
