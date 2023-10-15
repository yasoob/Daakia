defmodule Daakia.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  actions do
    defaults [:read, :update]
  end

  authentication do
    api Daakia.Accounts

    strategies do
      password :password do
        identity_field :email
        sign_in_tokens_enabled? true
        confirmation_required?(false)

        resettable do
          sender Daakia.Accounts.User.Senders.SendPasswordResetEmail
        end
      end
    end

    tokens do
      enabled? true
      token_resource Daakia.Accounts.Token

      signing_secret Daakia.Accounts.Secrets
    end
  end

  postgres do
    table "users"
    repo Daakia.Repo
  end

  identities do
    identity :unique_email, [:email]
  end
end
