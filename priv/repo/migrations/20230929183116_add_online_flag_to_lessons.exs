defmodule Noctua.Repo.Migrations.AddOnlineFlagToLessons do
  use Ecto.Migration

  def change do
    alter table(:lessons) do
      add :online, :boolean
    end
  end
end
