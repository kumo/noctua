defmodule Noctua.Repo do
  use Ecto.Repo,
    otp_app: :noctua,
    adapter: Ecto.Adapters.Postgres
end
