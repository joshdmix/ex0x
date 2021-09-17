defmodule Ex0x.Repo do
  use Ecto.Repo,
    otp_app: :ex0x,
    adapter: Ecto.Adapters.Postgres
end
