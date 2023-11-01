defmodule Noctua.Repo.Migrations.AddAddressToTeacher do
  use Ecto.Migration

  def change do
    alter table(:teachers) do
      add :address, :map
    end
  end
end
