defmodule Daakia.Newsletters do
  use Ash.Api

  authorization do
    authorize :by_default
  end

  resources do
    resource Daakia.Newsletters.Campaign
  end
end
