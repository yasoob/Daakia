defmodule Daakia.Newsletters.Subscriber do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "subscribers"
    repo Daakia.Repo
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:create) do
      # authorize_if actor_present()
      authorize_if always()
    end

    policy action_type(:update) do
      authorize_if relates_to_actor_via(:user)
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  code_interface do
    define_for Daakia.Newsletters
    define :get_by_id, args: [:id], action: :by_id
    define :create_new_subscriber, action: :new_subscriber
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    create :new_subscriber do
      primary? true
      accept [:email, :name, :attributes]
      argument :list_id, :uuid, allow_nil?: false

      # change fn changeset, _context ->
      #   Ash.Changeset.after_action(changeset, fn changeset, subscriber ->
      #     Daakia.Newsletters.SubscriberList.create!(
      #       subscriber.id,
      #       changeset.arguments.list_id,
      #       :confirmed
      #     )

      #     {:ok, subscriber}
      #   end)
      # end

      # change fn changeset, _context ->
      #   # IO.inspect("are you getting here?")

      #   Ash.Changeset.after_action(changeset, fn changeset, subscriber ->
      #     # IO.inspect("how about here?")

      #     Daakia.Newsletters.SubscriberList.create!(
      #       subscriber.id,
      #       changeset.arguments.list_id,
      #       :confirmed
      #     )

      #     {:ok, subscriber}
      #   end)
      # end
    end

    # create :new_subscriber do
    #   primary? true
    #   accept [:email, :name, :attributes, :status]
    #   change relate_actor(:user)
    # end

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

    attribute :email, :ci_string do
      allow_nil? false
    end

    attribute :name, :string do
      allow_nil? true
    end

    attribute :attributes, :map do
      allow_nil? false
      default %{}
    end

    attribute :status, :atom do
      allow_nil? false
      default :enabled
      constraints one_of: [:enabled, :disabled, :blocklisted]
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  identities do
    identity :unique_email, [:email]
  end

  relationships do
    many_to_many :lists, Daakia.Newsletters.List do
      through Daakia.Newsletters.SubscriberList
      source_attribute_on_join_resource :subscriber_id
      destination_attribute_on_join_resource :list_id
      join_relationship :list_subscribers
    end

    # belongs_to :list, Daakia.Newsletters.List do
    #   api Daakia.Newsletters
    #   writable? true
    #   allow_nil? false
    # end
  end
end
