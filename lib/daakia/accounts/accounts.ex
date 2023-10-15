defmodule Daakia.Accounts do
  use Ash.Api

  resources do
    resource Daakia.Accounts.User
    resource Daakia.Accounts.Token
  end
end
