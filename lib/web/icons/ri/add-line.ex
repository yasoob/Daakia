defmodule Iconify.Ri.AddLine do
  @moduledoc false
  use Phoenix.Component
  def render(assigns) do
    ~H"""
    <svg data-icon="add-line" xmlns="http://www.w3.org/2000/svg" role="img" class={@class} viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M11 11V5h2v6h6v2h-6v6h-2v-6H5v-2h6Z"></path></svg>
    """
  end
end
