defmodule Noctua.Timetabling.Lesson do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "lessons" do
    field :ended_at, :naive_datetime # I wonder if when is more suitable? I could just do time for start and end
    field :note, :string
    field :started_at, :naive_datetime
    field :date, :string, virtual: true
    field :time, :string, virtual: true
    belongs_to :teacher, Noctua.Teaching.Teacher
    belongs_to :student, Noctua.Enroling.Student

    timestamps()
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:started_at, :ended_at, :note, :student_id, :teacher_id, :date, :time])
    |> timey_wimey()
    |> validate_required([:started_at, :ended_at, :student_id, :teacher_id])
  end

  def ordered(query) do
    from c in query, order_by: c.started_at
  end

  def today(query) do
    today = Timex.now() |> Timex.beginning_of_day()

    from c in query, where: c.started_at >= ^today
  end

  defp timey_wimey(changeset) do
    case changeset do
      %Ecto.Changeset{
        valid?: true,
        changes: %{date: date, time: time}
      } ->
        case Timex.parse("#{date} #{time}", "{D}/{M}/{YYYY} {h24}:{m}") do
          {:ok, date} ->
            changeset
            |> put_change(:started_at, date)
            |> put_change(:ended_at, Timex.shift(date, hours: 1))

          {:error, _} ->
            add_error(changeset, :date, "Invalid Date")
        end
      _ ->
        changeset
    end
  end
end
