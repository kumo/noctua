defmodule Noctua.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :student_id, references(:students, on_delete: :delete_all)
      add :parent_id, references(:parents, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:permissions, [:student_id])
    create index(:permissions, [:parent_id])
  end
end
