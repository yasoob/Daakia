defmodule Iconify.Ri.Home6Line do
  @moduledoc false
  use Phoenix.Component
  def render(assigns) do
    ~H"""
    <svg data-icon="home-6-line" xmlns="http://www.w3.org/2000/svg" role="img" class={@class} viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M21 20a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9.489a1 1 0 0 1 .386-.79l8-6.222a1 1 0 0 1 1.228 0l8 6.222a1 1 0 0 1 .386.79v10.51Zm-2-1V9.978l-7-5.445l-7 5.445V19h14ZM7 15h10v2H7v-2Z"></path></svg>
    """
  end
end
