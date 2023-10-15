defmodule DaakiaWeb.HomeLive do
  # alias DaakiaWeb.LayoutHelpers
  use DaakiaWeb, :live_view

  use Phoenix.Component

  def mount(_, _session, socket) do
    {:ok, socket}
  end

  def get_chart_data() do
    # raw_data = [[175, 60], [190, 80], [180, 75]]
    raw_data = [
      %{
        name: "Subscribers",
        data: %{
          "2013-05-27 07:00:00 UTC": 2,
          "2013-07-27 07:01:00 UTC": 5,
          "2013-07-27 07:02:00 UTC": 3,
          "2013-07-27 07:03:00 UTC": 3,
          "2013-07-27 07:04:00 UTC": 2,
          "2013-07-27 07:05:00 UTC": 5,
          "2013-07-27 07:06:00 UTC": 1,
          "2013-07-27 07:07:00 UTC": 3,
          "2013-07-27 07:08:00 UTC": 4,
          "2013-07-27 07:09:00 UTC": 3,
          "2013-07-27 07:10:00 UTC": 2
        }
      }
    ]

    Jason.encode!(raw_data)
  end

  def render(assigns) do
    IO.puts(inspect(assigns))

    ~H"""
    <%!-- <LayoutHelpers.sidebar sidebar_menu={@sidebar_menu} current_path={~p"/"} page_title="Dashboard"> --%>
    <.greeting />
    <%!-- <.chart_grid /> --%>
    <%!-- </LayoutHelpers.sidebar> --%>
    """
  end

  # def chart_grid(assigns) do
  #   ~H"""
  #   <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 -mx-4

  #     xl:[&>*:nth-child(3n+1)]:border-l-0 xl:[&>*:nth-child(3n)]:border-l">
  #     <.individual_chart id="1" />
  #     <.individual_chart id="2" />
  #     <.individual_chart id="3" />
  #     <.individual_chart id="4" />
  #     <.individual_chart id="5" />
  #     <.individual_chart id="6" />
  #   </div>
  #   """
  # end

  # def individual_chart(assigns) do
  #   ~H"""
  #   <div class="flex flex-col space-y-4 border-t border-l border-slate-200 p-4">
  #     <div class="px-4 flex flex-col space-y-2">
  #       <h2>Total Audience</h2>
  #       <h3 class="font-bold text-2xl">5000</h3>
  #       <div class="flex items-center">
  #         <.svg name="upward-trend" class="h-5 w-5 stroke-2 text-green-600 mr-3" />
  #         <span>2.1% vs last period</span>
  #       </div>
  #     </div>
  #     <div id={"chart-#{@id}"} phx-update="ignore" phx-hook="RenderChart">
  #       <%= get_chart_data()
  #       |> Chartkick.area_chart(
  #         height: "135px",
  #         legend: false,
  #         library: %{yAxis: %{visible: false}, xAxis: %{tickColor: "transparent", lineWidth: 0}}
  #       )
  #       |> Phoenix.HTML.raw() %>
  #     </div>
  #   </div>
  #   """
  # end

  def greeting(assigns) do
    ~H"""
    <div class="px-4 flex flex-col mb-10 space-y-2">
      <span class="text-lg">Hi there Yasoob! 👋</span>
      <span class="text-md">Showing key metrics overview for period Jan 1 — Jan 31</span>
    </div>
    """
  end
end
