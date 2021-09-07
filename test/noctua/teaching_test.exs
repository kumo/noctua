defmodule Noctua.TeachingTest do
  use Noctua.DataCase

  alias Noctua.Teaching

  describe "teachers" do
    alias Noctua.Teaching.Teacher

    import Noctua.TeachingFixtures

    @invalid_attrs %{first_name: nil, last_name: nil}

    test "list_teachers/0 returns all teachers" do
      teacher = teacher_fixture()
      assert Teaching.list_teachers() == [teacher]
    end

    test "get_teacher!/1 returns the teacher with given id" do
      teacher = teacher_fixture()
      assert Teaching.get_teacher!(teacher.id) == teacher
    end

    test "create_teacher/1 with valid data creates a teacher" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name"}

      assert {:ok, %Teacher{} = teacher} = Teaching.create_teacher(valid_attrs)
      assert teacher.first_name == "some first_name"
      assert teacher.last_name == "some last_name"
    end

    test "create_teacher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teaching.create_teacher(@invalid_attrs)
    end

    test "update_teacher/2 with valid data updates the teacher" do
      teacher = teacher_fixture()
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name"}

      assert {:ok, %Teacher{} = teacher} = Teaching.update_teacher(teacher, update_attrs)
      assert teacher.first_name == "some updated first_name"
      assert teacher.last_name == "some updated last_name"
    end

    test "update_teacher/2 with invalid data returns error changeset" do
      teacher = teacher_fixture()
      assert {:error, %Ecto.Changeset{}} = Teaching.update_teacher(teacher, @invalid_attrs)
      assert teacher == Teaching.get_teacher!(teacher.id)
    end

    test "delete_teacher/1 deletes the teacher" do
      teacher = teacher_fixture()
      assert {:ok, %Teacher{}} = Teaching.delete_teacher(teacher)
      assert_raise Ecto.NoResultsError, fn -> Teaching.get_teacher!(teacher.id) end
    end

    test "change_teacher/1 returns a teacher changeset" do
      teacher = teacher_fixture()
      assert %Ecto.Changeset{} = Teaching.change_teacher(teacher)
    end
  end
end
