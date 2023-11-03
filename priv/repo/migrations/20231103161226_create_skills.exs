defmodule Noctua.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :teacher_id, references(:teachers, on_delete: :delete_all)
      add :subject_id, references(:subjects, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:skills, [:teacher_id, :subject_id])
  end
end
