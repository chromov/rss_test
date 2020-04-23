defmodule InnoTest.Repo do
  use Ecto.Repo,
    otp_app: :inno_test,
    adapter: Ecto.Adapters.Postgres
end
