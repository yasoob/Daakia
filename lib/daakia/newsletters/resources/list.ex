defmodule Daakia.Newsletters.List do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "lists"
    repo Daakia.Repo
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:create) do
      authorize_if actor_present()
    end

    policy action_type(:update) do
      authorize_if relates_to_actor_via(:owner)
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:owner)
    end
  end

  code_interface do
    define_for Daakia.Newsletters
    define :get_by_id, args: [:id], action: :by_id
    define :create_new_list, action: :create_new_list
    define :read
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    create :create_new_list do
      primary? true
      accept [:name, :description, :type, :optin]
      argument :subscribers, {:array, :map}
      change relate_actor(:owner)

      change manage_relationship(:subscribers,
               type: :append_and_remove,
               on_no_match: :create
             )
    end

    read :by_id do
      # This action has one argument :id of type :uuid
      argument :id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(id == ^arg(:id))
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :description, :string do
      allow_nil? true
    end

    attribute :type, :atom do
      allow_nil? false
      constraints one_of: [:public, :private, :temporary]
    end

    attribute :optin, :atom do
      allow_nil? false
      constraints one_of: [:single, :double]
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :owner, Daakia.Accounts.User do
      api Daakia.Accounts
      writable? true
      allow_nil? false
    end

    # has_many :subscribers, Daakia.Newsletters.Subscriber
    many_to_many :subscribers, Daakia.Newsletters.Subscriber do
      through Daakia.Newsletters.SubscriberList
      source_attribute_on_join_resource :list_id
      destination_attribute_on_join_resource :subscriber_id
    end
  end
end
