defmodule Noctua.Repo.Migrations.CreateParents do
  use Ecto.Migration

  def change do
    create table(:parents) do
      add :first_name, :string
      add :last_name, :string

      add :archived, :boolean
      add :address, :map

      timestamps()
    end
  end
end
