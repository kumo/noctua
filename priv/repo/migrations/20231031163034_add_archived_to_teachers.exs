defmodule Noctua.Repo.Migrations.AddArchivedToTeachers do
  use Ecto.Migration

  def change do
    alter table(:teachers) do
      add :archived, :boolean
   end
  end
end
