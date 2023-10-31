defmodule Noctua.Repo.Migrations.AddArchivedToStudents do
  use Ecto.Migration

  def change do
    alter table(:students) do
      add :archived, :bool
   end
  end
end
