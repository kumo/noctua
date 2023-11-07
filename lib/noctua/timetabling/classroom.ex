defmodule Noctua.Timetabling.Classroom do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "classrooms" do
    # I wonder if when is more suitable? I could just do time for start and end
    field :ended_at, :naive_datetime
    field :note, :string
    field :started_at, :naive_datetime
    # field :late_minutes, :integer
    # field :left_early_minutes, :integer
    # field :absent, :boolean
    field :online, :boolean
    field :date, :string, virtual: true
    field :time, :string, virtual: true
    belongs_to :teacher, Noctua.Teaching.Teacher
    belongs_to :subject, Noctua.Timetabling.Subject
    # belongs_to :student, Noctua.Enroling.Student

    many_to_many :students, Noctua.Enroling.Student,
      join_through: Noctua.Timetabling.Absence,
      on_delete: :delete_all,
      on_replace: :delete

    has_many :absences, Noctua.Timetabling.Absence

    # has_many :preferences, Preference, on_replace: :delete
    # has_many :cats, :through => :preferences

    field(:student_list, {:array, :string}, virtual: true, default: [])

    timestamps()
  end

  @doc false
  def changeset(classroom, attrs) do
    classroom
    |> cast(attrs, [
      :started_at,
      :ended_at,
      # :note,
      # :student_id,
      :teacher_id,
      :subject_id,
      :date,
      :time,
      # :late_minutes,
      # :left_early_minutes,
      # :absent,
      :online
    ])
    |> put_assoc(:students, fetch_students(attrs))
    |> timey_wimey()
    |> validate_required([:started_at, :ended_at, :teacher_id, :subject_id])
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

  def ordered(query) do
    from c in query, order_by: c.started_at
  end

  def reverse_ordered(query) do
    from c in query, order_by: [desc: c.started_at]
  end

  def absent(query) do
    from c in query, where: c.absent == true
  end

  def present(query) do
    from c in query, where: is_nil(c.absent) or c.absent != true
  end

  def today(query) do
    today = Timex.now() |> Timex.beginning_of_day()

    from c in query, where: c.started_at >= ^today
  end

  def this_week(query) do
    this_week = Timex.now() |> Timex.beginning_of_week()

    from c in query, where: c.started_at >= ^this_week
  end

  def this_month(query) do
    this_month = Timex.now() |> Timex.beginning_of_month()

    from c in query, where: c.started_at >= ^this_month
  end

  def last_month(query) do
    this_month = Timex.now() |> Timex.beginning_of_month()
    last_month = Timex.now() |> Timex.shift(months: -1) |> Timex.beginning_of_month()

    from c in query, where: c.started_at >= ^last_month and c.started_at < ^this_month
  end

  defp count_for(query, attribute) do
    from q in query,
      group_by: field(q, ^attribute),
      select: %{link_id: field(q, ^attribute), count: count(q.id)}
  end

  def count_for_teachers(query) do
    # query
    # |> group_by(:teacher_id)
    # |> select([l], %{link_id: l.teacher_id, count: count(l.id)})      
    count_for(query, :teacher_id)
  end

  def count_for_students(query) do
    # query
    # |> group_by(:student_id)
    # |> select([l], %{link_id: l.student_id, count: count(l.id)})      
    count_for(query, :student_id)
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
            # FIXME: remove truncate when Timex updates
            |> put_change(:ended_at, NaiveDateTime.truncate(Timex.shift(date, hours: 1), :second))

          {:error, _} ->
            add_error(changeset, :date, "Invalid Date")
        end

      _ ->
        changeset
    end
  end
end
