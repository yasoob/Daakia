defmodule Iconify.Ri.Contrast2Line do
  @moduledoc false
  use Phoenix.Component
  def render(assigns) do
    ~H"""
    <svg data-icon="contrast-2-line" xmlns="http://www.w3.org/2000/svg" role="img" class={@class} viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M12 21.997c-5.523 0-10-4.478-10-10c0-5.523 4.477-10 10-10s10 4.477 10 10c0 5.522-4.477 10-10 10Zm0-2a8 8 0 1 0 0-16a8 8 0 0 0 0 16Zm-5-4.681a8.965 8.965 0 0 0 5.707-2.612a8.965 8.965 0 0 0 2.612-5.707A6 6 0 1 1 7 15.316Z"></path></svg>
    """
  end
end
