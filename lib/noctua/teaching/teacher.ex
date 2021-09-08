defmodule Noctua.Teaching.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "teachers" do
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end

  def alphabetical(query) do
    from c in query, order_by: c.last_name
  end
end
