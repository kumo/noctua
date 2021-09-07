defmodule Noctua.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add :started_at, :naive_datetime
      add :ended_at, :naive_datetime
      add :note, :string
      add :teacher_id, references(:teachers, on_delete: :delete_all)
      add :student_id, references(:students, on_delete: :delete_all)

      timestamps()
    end

    create index(:lessons, [:teacher_id])
    create index(:lessons, [:student_id])
    create unique_index(:lessons, [:teacher_id, :student_id])
  end
end
