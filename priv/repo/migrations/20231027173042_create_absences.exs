defmodule Noctua.Repo.Migrations.CreateAbsences do
  use Ecto.Migration

  def change do
    create table(:absences) do
      add :student_id, references(:students, on_delete: :nothing)
      add :classroom_id, references(:classrooms, on_delete: :nothing)

      add :late, :boolean

      timestamps(type: :utc_datetime)
    end

    create index(:absences, [:student_id])
    create index(:absences, [:classroom_id])
  end
end
