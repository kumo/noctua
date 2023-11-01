defmodule NoctuaWeb.ClassroomView do
  use NoctuaWeb, :view

  def student_select(f, _changeset) do
    student_opts =
      for student <- Noctua.Enroling.list_alphabetical_students(),
          do: [key: student.first_name <> " " <> student.last_name, value: student.id]

    select(f, :student_id, student_opts,
      prompt: "",
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def teacher_select(f, _changeset, %{role: :Teacher} = user) do
    teacher_opts = [
      [key: user.teacher.last_name <> " " <> user.teacher.first_name, value: user.teacher.id]
    ]

    select(f, :teacher_id, teacher_opts,
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def teacher_select(f, _changeset, _user) do
    teacher_opts =
      for teacher <- Noctua.Teaching.list_alphabetical_teachers(),
          do: [key: teacher.last_name <> " " <> teacher.first_name, value: teacher.id]

    select(f, :teacher_id, teacher_opts,
      prompt: "",
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def simple_time_select(f, _changeset) do
    # Probably should be able to select no time, but that messes up the changeset code
    # times = Enum.to_list(8..17) |> Enum.map(fn x -> "#{x}:00" |> String.pad_leading(5, "0") end)
    times = ["09:05": "09:05", "09:55": "09:55", "11:00": "11:00", "11:50": "11:50", "12:40": "12:40", "13:30": "13:30", "15:20": "15:20", "16:10": "16:10", "17:00": "17:00"];

    select(f, :time, times,
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def simple_late_select(f, _changeset) do
    times =
      for time <- Enum.take_every(0..20, 5),
          do: [key: "#{time} minuti", value: time]

    select(f, :late_minutes, times,
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def simple_left_early_select(f, _changeset) do
    times =
      for time <- Enum.take_every(0..20, 5),
          do: [key: "#{time} minuti", value: time]

    select(f, :left_early_minutes, times,
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def simple_bool_select(f, _changeset) do
    select(f, :time, [No: 0, Sì: 1],
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def simple_date_select(f, _changeset) do
    today = Timex.now() |> Timex.beginning_of_day()
    today_str = Timex.format!(today, "{0D}/{0M}/{YYYY}")

    yesterday = Timex.shift(today, days: -1)
    yesterday_str = Timex.format!(yesterday, "{0D}/{0M}/{YYYY}")

    two_days_ago = Timex.shift(yesterday, days: -1)
    two_days_ago_str = Timex.format!(two_days_ago, "{0D}/{0M}/{YYYY}")

    three_days_ago = Timex.shift(two_days_ago, days: -1)
    three_days_ago_str = Timex.format!(three_days_ago, "{0D}/{0M}/{YYYY}")

    select(
      f,
      :date,
      [
        "Oggi (#{today_str})": today_str,
        "Ieri (#{yesterday_str})": yesterday_str,
        "#{two_days_ago_str}": two_days_ago_str,
        "#{three_days_ago_str}": three_days_ago_str
      ],
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def subject_select(f, _changeset) do
    subject_opts =
      for subject <- Noctua.Timetabling.list_subjects(),
          do: [key: subject.name, value: subject.id]

    select(f, :subject_id, subject_opts,
      prompt: "",
      class:
        "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    )
  end

  def title("show.html", assigns) do
    assigns.classroom.student.first_name <> " " <> assigns.classroom.student.last_name
  end

  def title("index.html", _assigns) do
    "Elenco Classi"
  end

  def title("edit.html", _assigns) do
    "Modifica Classe"
  end

  def title(_action, _assigns), do: "Classi"
end
