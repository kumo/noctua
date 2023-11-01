defmodule Noctua.Repo.Migrations.AddMagicTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :magic_token, :string
      add :magic_token_created_at, :utc_datetime
    end
  end
end
