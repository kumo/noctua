defmodule NoctuaWeb.LessonControllerTest do
  use NoctuaWeb.ConnCase, async: true

  import Noctua.TimetablingFixtures
  import Noctua.EnrolingFixtures
  import Noctua.TeachingFixtures

  # @create_attrs %{
  #   ended_at: ~N[2021-09-06 12:37:00],
  #   note: "some note",
  #   started_at: ~N[2021-09-06 12:37:00]
  # }
  @update_attrs %{
    ended_at: ~N[2021-09-07 12:37:00],
    note: "some updated note",
    started_at: ~N[2021-09-07 12:37:00]
  }
  @invalid_attrs %{ended_at: nil, note: nil, started_at: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all lessons", %{conn: conn} do
      conn = get(conn, Routes.lesson_path(conn, :index))
      assert html_response(conn, 200) =~ "Registro"
    end
  end

  describe "new lesson" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.lesson_path(conn, :new))
      assert html_response(conn, 200) =~ "Nuovo lezione"
    end
  end

  describe "create lesson" do
    test "redirects to show when data is valid", %{conn: conn} do
      student = student_fixture()
      teacher = teacher_fixture()

      create_attrs = %{
        ended_at: ~N[2021-09-06 12:37:00],
        note: "some note",
        started_at: ~N[2021-09-06 12:37:00],
        student_id: student.id,
        teacher_id: teacher.id
      }

      conn = post(conn, Routes.lesson_path(conn, :create), lesson: create_attrs)

      assert redirected_to(conn) == Routes.lesson_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.lesson_path(conn, :create), lesson: @invalid_attrs)
      assert html_response(conn, 200) =~ "Nuovo lezione"
    end
  end

  describe "edit lesson" do
    setup [:create_lesson]

    test "renders form for editing chosen lesson", %{conn: conn, lesson: lesson} do
      conn = get(conn, Routes.lesson_path(conn, :edit, lesson))
      assert html_response(conn, 200) =~ "Salva"
    end
  end

  describe "update lesson" do
    setup [:create_lesson]

    test "redirects when data is valid", %{conn: conn, lesson: lesson} do
      conn = put(conn, Routes.lesson_path(conn, :update, lesson), lesson: @update_attrs)
      assert redirected_to(conn) == Routes.lesson_path(conn, :show, lesson)

      conn = get(conn, Routes.lesson_path(conn, :show, lesson))
      assert html_response(conn, 200) =~ "some updated note"
    end

    test "renders errors when data is invalid", %{conn: conn, lesson: lesson} do
      conn = put(conn, Routes.lesson_path(conn, :update, lesson), lesson: @invalid_attrs)
      assert html_response(conn, 200) =~ "Salva"
    end
  end

  describe "delete lesson" do
    setup [:create_lesson]

    test "deletes chosen lesson", %{conn: conn, lesson: lesson} do
      conn = delete(conn, Routes.lesson_path(conn, :delete, lesson))
      assert redirected_to(conn) == Routes.lesson_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.lesson_path(conn, :show, lesson))
      end
    end
  end

  defp create_lesson(_) do
    lesson_fixture = lesson_fixture()

    lesson = %{
      lesson_fixture
      | student: Noctua.Enroling.get_student!(lesson_fixture.student_id),
        teacher: Noctua.Teaching.get_teacher!(lesson_fixture.teacher_id)
    }

    %{lesson: lesson}
  end
end
