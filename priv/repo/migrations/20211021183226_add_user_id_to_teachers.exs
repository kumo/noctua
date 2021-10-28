defmodule Noctua.Repo.Migrations.AddUserIdToTeachers do
  use Ecto.Migration

def change do
    alter table(:teachers) do
      add :user_id, references(:users, on_delete: :delete_all),
                      null: true # let's allow teacher without an account
    end

    create unique_index(:teachers, [:user_id])
  end
end
