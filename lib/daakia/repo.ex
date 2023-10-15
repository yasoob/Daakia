defmodule Daakia.Repo do
  use AshPostgres.Repo,
    otp_app: :daakia

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
