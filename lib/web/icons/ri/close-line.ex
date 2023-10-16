defmodule Iconify.Ri.CloseLine do
  @moduledoc false
  use Phoenix.Component
  def render(assigns) do
    ~H"""
    <svg data-icon="close-line" xmlns="http://www.w3.org/2000/svg" role="img" class={@class} viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="m12 10.586l4.95-4.95l1.415 1.415l-4.95 4.95l4.95 4.95l-1.415 1.414l-4.95-4.95l-4.95 4.95l-1.413-1.415l4.95-4.95l-4.95-4.95L7.05 5.638l4.95 4.95Z"></path></svg>
    """
  end
end
