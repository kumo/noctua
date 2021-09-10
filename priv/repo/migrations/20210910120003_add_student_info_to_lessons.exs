defmodule Noctua.Repo.Migrations.AddStudentInfoToLessons do
  use Ecto.Migration

  def change do
    alter table(:lessons) do
      add :late_minutes, :integer
      add :left_early_minutes, :integer
      add :absent, :boolean
    end
  end
end
