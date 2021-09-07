defmodule Noctua.EnrolingTest do
  use Noctua.DataCase

  alias Noctua.Enroling

  describe "students" do
    alias Noctua.Enroling.Student

    import Noctua.EnrolingFixtures

    @invalid_attrs %{first_name: nil, last_name: nil}

    test "list_students/0 returns all students" do
      student = student_fixture()
      assert Enroling.list_students() == [student]
    end

    test "get_student!/1 returns the student with given id" do
      student = student_fixture()
      assert Enroling.get_student!(student.id) == student
    end

    test "create_student/1 with valid data creates a student" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name"}

      assert {:ok, %Student{} = student} = Enroling.create_student(valid_attrs)
      assert student.first_name == "some first_name"
      assert student.last_name == "some last_name"
    end

    test "create_student/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Enroling.create_student(@invalid_attrs)
    end

    test "update_student/2 with valid data updates the student" do
      student = student_fixture()
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name"}

      assert {:ok, %Student{} = student} = Enroling.update_student(student, update_attrs)
      assert student.first_name == "some updated first_name"
      assert student.last_name == "some updated last_name"
    end

    test "update_student/2 with invalid data returns error changeset" do
      student = student_fixture()
      assert {:error, %Ecto.Changeset{}} = Enroling.update_student(student, @invalid_attrs)
      assert student == Enroling.get_student!(student.id)
    end

    test "delete_student/1 deletes the student" do
      student = student_fixture()
      assert {:ok, %Student{}} = Enroling.delete_student(student)
      assert_raise Ecto.NoResultsError, fn -> Enroling.get_student!(student.id) end
    end

    test "change_student/1 returns a student changeset" do
      student = student_fixture()
      assert %Ecto.Changeset{} = Enroling.change_student(student)
    end
  end
end
