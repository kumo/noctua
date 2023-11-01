defmodule Noctua.Teacher.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias Noctua.Teacher.Address

  embedded_schema do
    field :phone1, :string
  end

  @doc false
  def changeset(%Address{} = address, attrs) do
    address
    |> cast(attrs, [:phone1])
  end
end
