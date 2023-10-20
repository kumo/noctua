defmodule Noctua.Repo.Migrations.CreateClassrooms do
  use Ecto.Migration

  def change do
    create table(:classrooms) do
      add :started_at, :naive_datetime
      add :ended_at, :naive_datetime
      add :note, :string
      add :online, :boolean
      add :teacher_id, references(:teachers, on_delete: :delete_all)

      timestamps()
    end

    create index(:classrooms, [:teacher_id])
  end
end
