defmodule Noctua.Repo.Migrations.CreateTeachers do
  use Ecto.Migration

  def change do
    create table(:teachers) do
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end
  end
end
