defmodule NoctuaWeb.StudentControllerTest do
  use NoctuaWeb.ConnCase, async: true

  import Noctua.EnrolingFixtures

  @create_attrs %{first_name: "some first_name", last_name: "some last_name"}
  @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name"}
  @invalid_attrs %{first_name: nil, last_name: nil}

  setup :register_and_log_in_user

  describe "index" do
    test "lists all students", %{conn: conn} do
      conn = get(conn, Routes.student_path(conn, :index))
      assert html_response(conn, 200) =~ "Studenti"
    end
  end

  describe "new student" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.student_path(conn, :new))
      assert html_response(conn, 200) =~ "Salva"
    end
  end

  describe "create student" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.student_path(conn, :create), student: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.student_path(conn, :show, id)

      conn = get(conn, Routes.student_path(conn, :show, id))
      assert html_response(conn, 200) =~ "some first_name"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.student_path(conn, :create), student: @invalid_attrs)
      assert html_response(conn, 200) =~ "Salva"
    end
  end

  describe "edit student" do
    setup [:create_student]

    test "renders form for editing chosen student", %{conn: conn, student: student} do
      conn = get(conn, Routes.student_path(conn, :edit, student))
      assert html_response(conn, 200) =~ "Studenti"
      assert html_response(conn, 200) =~ student.last_name
    end
  end

  describe "update student" do
    setup [:create_student]

    test "redirects when data is valid", %{conn: conn, student: student} do
      conn = put(conn, Routes.student_path(conn, :update, student), student: @update_attrs)
      assert redirected_to(conn) == Routes.student_path(conn, :show, student)

      conn = get(conn, Routes.student_path(conn, :show, student))
      assert html_response(conn, 200) =~ "some updated first_name"
    end

    test "renders errors when data is invalid", %{conn: conn, student: student} do
      conn = put(conn, Routes.student_path(conn, :update, student), student: @invalid_attrs)
      assert html_response(conn, 200) =~ "Studenti"
      assert html_response(conn, 200) =~ student.last_name
    end
  end

  describe "delete student" do
    setup [:create_student]

    test "deletes chosen student", %{conn: conn, student: student} do
      conn = delete(conn, Routes.student_path(conn, :delete, student))
      assert redirected_to(conn) == Routes.student_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.student_path(conn, :show, student))
      end
    end
  end

  defp create_student(_) do
    student = student_fixture()
    %{student: student}
  end
end
