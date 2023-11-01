defmodule Noctua.Repo.Migrations.AddUserToParents do
  use Ecto.Migration

  def change do
    # add association to parent to user table
    alter table(:parents) do
      add :user_id, references(:users)
    end

    create unique_index(:parents, [:user_id])
  end
end
