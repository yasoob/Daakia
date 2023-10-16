defmodule Daakia.Newsletters.SubscriberList do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "subscriber_lists"
    repo Daakia.Repo
  end

  code_interface do
    define_for Daakia.Newsletters
    define :create, args: [:subscriber_id, :list_id, :status]
    # define :create_new_relation, action: :create_new_relation
  end

  attributes do
    attribute :status, :atom do
      allow_nil? false
      constraints one_of: [:unconfirmed, :confirmed, :unsubscribed]
    end

    attribute :meta, :map do
      allow_nil? false
      default %{}
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    # create :create_new_relation do
    #   primary? true
    #   # accept [:status]
    # end
  end

  # relationships do
  #   belongs_to :subscriber, Daakia.Newsletters.Subscriber, primary_key?: true, allow_nil?: false
  #   belongs_to :list, Daakia.Newsletters.List, primary_key?: true, allow_nil?: false
  # end

  relationships do
    belongs_to :subscriber, Daakia.Newsletters.Subscriber,
      primary_key?: true,
      allow_nil?: false,
      attribute_writable?: true

    belongs_to :list, Daakia.Newsletters.List,
      primary_key?: true,
      allow_nil?: false,
      attribute_writable?: true
  end
end
