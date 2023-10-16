defmodule Daakia.Newsletters do
  use Ash.Api

  # authorization do
  #   authorize :by_default
  # end

  resources do
    resource Daakia.Newsletters.Campaign
    resource Daakia.Newsletters.Subscriber
    resource Daakia.Newsletters.List
    resource Daakia.Newsletters.SubscriberList
  end
end
