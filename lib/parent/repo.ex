defmodule Parent.Repo do
  use Ecto.Repo,
    otp_app: :parent,
    adapter: Ecto.Adapters.Postgres
end
