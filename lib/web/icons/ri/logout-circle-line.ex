defmodule Iconify.Ri.LogoutCircleLine do
  @moduledoc false
  use Phoenix.Component
  def render(assigns) do
    ~H"""
    <svg data-icon="logout-circle-line" xmlns="http://www.w3.org/2000/svg" role="img" class={@class} viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M5 11h8v2H5v3l-5-4l5-4v3Zm-1 7h2.708a8 8 0 1 0 0-12H4a9.985 9.985 0 0 1 8-4c5.523 0 10 4.477 10 10s-4.477 10-10 10a9.985 9.985 0 0 1-8-4Z"></path></svg>
    """
  end
end
