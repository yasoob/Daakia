defmodule Daakia.Newsletters.Campaign do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "campaigns"
    repo Daakia.Repo
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action(:list_recent) do
      authorize_if relates_to_actor_via(:user)
    end

    policy action_type(:create) do
      authorize_if actor_present()
    end

    policy action_type(:update) do
      authorize_if relates_to_actor_via(:user)
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  # code_interface do
  #   define_for Daakia.Newsletters
  #   define :new_empty_email, args: [], action: :new
  #   define :get_by_id, args: [:id], action: :by_id
  #   define :list_recent
  # end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :subject, :string do
      allow_nil? false
    end

    attribute :from_email, :string do
      allow_nil? false
    end

    attribute :body, :string do
      allow_nil? false
    end

    attribute :altbody, :string do
      allow_nil? true
    end

    attribute :content_type, :atom do
      allow_nil? false
      constraints one_of: [:richtext, :html, :plain, :markdown]
      default :richtext
    end

    attribute :send_at, :utc_datetime do
      allow_nil? true
    end

    attribute :headers, :map do
      allow_nil? false
      default %{}
    end

    attribute :status, :atom do
      allow_nil? false
      constraints one_of: [:draft, :running, :scheduled, :paused, :cancelled, :finished]
      default :draft
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, Daakia.Accounts.User do
      api Daakia.Accounts
      writable? true
      allow_nil? false
    end
  end
end
