defmodule Noctua.Repo.Migrations.AddSubjectToClassroom do
  use Ecto.Migration

  def change do
    alter table(:classrooms) do
      add :subject_id, references(:subjects)
    end

    create unique_index(:classrooms, [:subject_id])

  end
end
