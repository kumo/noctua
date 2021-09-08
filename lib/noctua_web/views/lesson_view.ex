defmodule NoctuaWeb.LessonView do
  use NoctuaWeb, :view

  def student_select(f, changeset) do
    student_opts =
      for student <- Noctua.Enroling.list_alphabetical_students(),
          do: [key: student.first_name <> " " <> student.last_name, value: student.id]

    select(f, :student_id, student_opts, prompt: "", class: "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm")
  end

  def teacher_select(f, changeset) do
    teacher_opts =
      for teacher <- Noctua.Teaching.list_alphabetical_teachers(),
          do: [key: teacher.first_name <> " " <> teacher.last_name, value: teacher.id]

    select(f, :teacher_id, teacher_opts, prompt: "", class: "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm")
  end
end
