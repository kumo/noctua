defmodule Noctua.TimetablingTest do
  use Noctua.DataCase

  alias Noctua.Timetabling

  describe "lessons" do
    alias Noctua.Timetabling.Lesson

    import Noctua.TimetablingFixtures
    import Noctua.TeachingFixtures
    import Noctua.EnrolingFixtures

    @invalid_attrs %{ended_at: nil, note: nil, started_at: nil, student_id: nil, teacher_id: nil}

    test "list_lessons/0 returns all lessons" do
      lesson = lesson_fixture()
      assert Timetabling.list_lessons() == [lesson]
    end

    test "get_lesson!/1 returns the lesson with given id" do
      lesson = lesson_fixture()
      assert Timetabling.get_lesson!(lesson.id) == lesson
    end

    test "get_lesson_with_users!/1 returns the lesson with given id" do
      lesson = lesson_fixture()

      lesson = %{
        lesson
        | student: Noctua.Enroling.get_student!(lesson.student_id),
          teacher: Noctua.Teaching.get_teacher!(lesson.teacher_id)
      }

      assert Timetabling.get_lesson_with_users!(lesson.id) == lesson
    end

    test "create_lesson/1 with valid data creates a lesson" do
      student = student_fixture()
      teacher = teacher_fixture()

      valid_attrs = %{
        ended_at: ~N[2021-09-06 12:37:00],
        note: "some note",
        started_at: ~N[2021-09-06 12:37:00],
        student_id: student.id,
        teacher_id: teacher.id
      }

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

      update_attrs = %{
        ended_at: ~N[2021-09-07 12:37:00],
        note: "some updated note",
        started_at: ~N[2021-09-07 12:37:00]
      }

      assert {:ok, %Lesson{} = lesson} = Timetabling.update_lesson(lesson, update_attrs)
      assert lesson.ended_at == ~N[2021-09-07 12:37:00]
      assert lesson.note == "some updated note"
      assert lesson.started_at == ~N[2021-09-07 12:37:00]
    end

    test "update_lesson/2 with valid student and teacher updates the lesson" do
      lesson = lesson_fixture()
      student = student_fixture()
      teacher = teacher_fixture()

      update_attrs = %{
        ended_at: ~N[2021-09-07 12:37:00],
        note: "some updated note",
        started_at: ~N[2021-09-07 12:37:00],
        student_id: student.id,
        teacher_id: teacher.id
      }

      assert {:ok, %Lesson{} = lesson} = Timetabling.update_lesson(lesson, update_attrs)
      assert lesson.ended_at == ~N[2021-09-07 12:37:00]
      assert lesson.note == "some updated note"
      assert lesson.started_at == ~N[2021-09-07 12:37:00]
      assert lesson.student_id == student.id
      assert lesson.teacher_id == teacher.id
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

  describe "subjects" do
    alias Noctua.Timetabling.Subject

    import Noctua.TimetablingFixtures

    @invalid_attrs %{name: nil}

    test "list_subjects/0 returns all subjects" do
      subject = subject_fixture()
      assert Timetabling.list_subjects() == [subject]
    end

    test "get_subject!/1 returns the subject with given id" do
      subject = subject_fixture()
      assert Timetabling.get_subject!(subject.id) == subject
    end

    test "create_subject/1 with valid data creates a subject" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Subject{} = subject} = Timetabling.create_subject(valid_attrs)
      assert subject.name == "some name"
    end

    test "create_subject/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timetabling.create_subject(@invalid_attrs)
    end

    test "update_subject/2 with valid data updates the subject" do
      subject = subject_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Subject{} = subject} = Timetabling.update_subject(subject, update_attrs)
      assert subject.name == "some updated name"
    end

    test "update_subject/2 with invalid data returns error changeset" do
      subject = subject_fixture()
      assert {:error, %Ecto.Changeset{}} = Timetabling.update_subject(subject, @invalid_attrs)
      assert subject == Timetabling.get_subject!(subject.id)
    end

    test "delete_subject/1 deletes the subject" do
      subject = subject_fixture()
      assert {:ok, %Subject{}} = Timetabling.delete_subject(subject)
      assert_raise Ecto.NoResultsError, fn -> Timetabling.get_subject!(subject.id) end
    end

    test "change_subject/1 returns a subject changeset" do
      subject = subject_fixture()
      assert %Ecto.Changeset{} = Timetabling.change_subject(subject)
    end
  end
end
