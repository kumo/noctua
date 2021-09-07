defmodule NoctuaWeb.LessonView do
  use NoctuaWeb, :view

  def student_select(f, changeset) do
    student_opts =
      for student <- Noctua.Enroling.list_students(),
          do: [key: student.last_name, value: student.id]

    select(f, :student_id, student_opts, prompt: "Choose the student")
  end

  def teacher_select(f, changeset) do
    teacher_opts =
      for teacher <- Noctua.Teaching.list_teachers(),
          do: [key: teacher.last_name, value: teacher.id]

    select(f, :teacher_id, teacher_opts, prompt: "Choose the teacher")
  end
end
