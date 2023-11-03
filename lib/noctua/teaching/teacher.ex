defmodule Noctua.Teaching.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Noctua.Timetabling.Lesson
  alias Noctua.Teacher.Address

  schema "teachers" do
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

    belongs_to :user, Noctua.Accounts.User
    # field :user_id, :integer

    many_to_many :subjects, Noctua.Timetabling.Subject,
      join_through: Noctua.Teaching.Skill,
      on_delete: :delete_all,
      on_replace: :delete

    embeds_one :address, Address

    field(:subject_list, {:array, :string}, virtual: true, default: [])

    timestamps()
  end

  @doc false
  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, [:first_name, :last_name, :archived])
    |> cast_embed(:address)
    |> put_assoc(:subjects, fetch_subjects(attrs))
    |> validate_required([:first_name, :last_name])
  end

  defp fetch_subjects(%{subject_list: ids}),
    do: fetch_subjects(%{"subject_list" => ids})

  defp fetch_subjects(%{"subject_list" => subject_ids}) do
    # Logger.error("fetch subjects")

    subjects =
      subject_ids
      |> Enum.reject(&(&1 == ""))
      |> Noctua.Timetabling.get_subjects()

    # Logger.error(dbg(subjects))
    subjects
  end

  defp fetch_subjects(_), do: []

  def alphabetical(query) do
    from c in query, order_by: c.last_name
  end

  def active(query) do
    from t in query,
      where: is_nil(t.archived) or t.archived != true
  end
end
