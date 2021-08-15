defmodule Breath.Repo do
  use Ecto.Repo,
    otp_app: :breath,
    adapter: Ecto.Adapters.Postgres
end
