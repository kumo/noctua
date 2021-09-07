defmodule Noctua.TimetablingTest do
  use Noctua.DataCase

  alias Noctua.Timetabling

  describe "lessons" do
    alias Noctua.Timetabling.Lesson

    import Noctua.TimetablingFixtures

    @invalid_attrs %{ended_at: nil, note: nil, started_at: nil}

    test "list_lessons/0 returns all lessons" do
      lesson = lesson_fixture()
      assert Timetabling.list_lessons() == [lesson]
    end

    test "get_lesson!/1 returns the lesson with given id" do
      lesson = lesson_fixture()
      assert Timetabling.get_lesson!(lesson.id) == lesson
    end

    test "create_lesson/1 with valid data creates a lesson" do
      valid_attrs = %{ended_at: ~N[2021-09-06 12:37:00], note: "some note", started_at: ~N[2021-09-06 12:37:00]}

      assert {:ok, %Lesson{} = lesson} = Timetabling.create_lesson(valid_attrs)
      assert lesson.ended_at == ~N[2021-09-06 12:37:00]
      assert lesson.note == "some note"
      assert lesson.started_at == ~N[2021-09-06 12:37:00]
    end

    test "create_lesson/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timetabling.create_lesson(@invalid_attrs)
    end

    test "update_lesson/2 with valid data updates the lesson" do
      lesson = lesson_fixture()
      update_attrs = %{ended_at: ~N[2021-09-07 12:37:00], note: "some updated note", started_at: ~N[2021-09-07 12:37:00]}

      assert {:ok, %Lesson{} = lesson} = Timetabling.update_lesson(lesson, update_attrs)
      assert lesson.ended_at == ~N[2021-09-07 12:37:00]
      assert lesson.note == "some updated note"
      assert lesson.started_at == ~N[2021-09-07 12:37:00]
    end

    test "update_lesson/2 with invalid data returns error changeset" do
      lesson = lesson_fixture()
      assert {:error, %Ecto.Changeset{}} = Timetabling.update_lesson(lesson, @invalid_attrs)
      assert lesson == Timetabling.get_lesson!(lesson.id)
    end

    test "delete_lesson/1 deletes the lesson" do
      lesson = lesson_fixture()
      assert {:ok, %Lesson{}} = Timetabling.delete_lesson(lesson)
      assert_raise Ecto.NoResultsError, fn -> Timetabling.get_lesson!(lesson.id) end
    end

    test "change_lesson/1 returns a lesson changeset" do
      lesson = lesson_fixture()
      assert %Ecto.Changeset{} = Timetabling.change_lesson(lesson)
    end
  end
end
