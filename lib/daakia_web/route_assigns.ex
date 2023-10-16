defmodule DaakiaWeb.RouteAssigns do
  import Phoenix.LiveView
  import Phoenix.Component
  use DaakiaWeb, :verified_routes

  def menu() do
    [
      # Top menu
      [
        %{
          # If this matches the `current_page` prop, it will be highlighted
          name: :dashboard,
          label: "Dashboard",
          icon: "ri:home-6-line",
          path: ~p"/"
        },
        %{
          name: :emails,
          label: "Campaigns",
          icon: "ri:send-plane-line",
          path: ~p"/campaigns"
        },
        %{
          name: :subscribers,
          label: "Subscribers",
          icon: "ri:group-line",
          path: ~p"/"
        }
      ],
      # Bottom menu
      [
        %{
          # If this matches the `current_page` prop, it will be highlighted
          name: :feedback,
          label: "Feedback",
          icon: "ri:feedback-line",
          path: ~p"/"
        },
        %{
          name: :settings,
          label: "Settings",
          icon: "ri:settings-3-line",
          path: ~p"/"
        }
      ]
    ]
  end

  def on_mount(:default, _params, _session, socket) do
    IO.puts("Onmount being called")

    socket =
      socket
      |> assign(sidebar_menu: menu())
      |> attach_hook(:set_menu_path, :handle_params, &manage_active_tabs/3)

    {:cont, socket}
  end

  defp manage_active_tabs(_params, url, socket) do
    {:cont, assign(socket, current_path: URI.parse(url).path)}
  end
end
