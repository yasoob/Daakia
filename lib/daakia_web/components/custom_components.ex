defmodule DaakiaWeb.CustomComponents do
  use DaakiaWeb, :html
  # import Phoenix.HTML.Tag
  import Iconify

  slot :title, doc: "the page title"
  attr :sidebar_menu, :map, default: nil
  attr :current_path, :string, default: nil

  def global_sidebar(assigns) do
    ~H"""
    <aside class="fixed z-40 lg:w-64">
      <.sidebar_backdrop />
      <div
        id="sidebar"
        class="flex flex-col absolute top-0 left-0 z-40 flex-shrink-0 w-64 h-screen py-4 overflow-y-auto transition-transform duration-200 ease-in-out transform border-r lg:static lg:left-auto lg:top-auto lg:translate-x-0 lg:overflow-y-auto no-scrollbar bg-slate-50 dark:bg-gray-900 border-gray-200 dark:border-gray-700 -translate-x-64"
        x-bind:class="sidebarOpen ? 'translate-x-0' : '-translate-x-64'"
        @click.away="sidebarOpen = false"
        @keydown.escape.window="sidebarOpen = false"
      >
        <div class="flex justify-between pr-3 mb-10 sm:px-2">
          <div>
            <.link navigate={~p"/"} class="flex px-3 py-1">
              <img src={~p"/images/logo.svg"} width="36" />
              <span class="ml-4 text-2xl font-bold text-indigo-500 self-center">
                Daakia
              </span>
            </.link>
          </div>
          <button
            class="text-gray-500 lg:hidden hover:text-gray-400"
            @click.stop="sidebarOpen = !sidebarOpen"
            aria-controls="sidebar"
            x-bind:aria-expanded="sidebarOpen"
            aria-expanded="false"
          >
            <span class="sr-only">
              Close sidebar
            </span>
            <.iconify icon="ri:close-line" class="w-6 h-6 text-base-content" />
          </button>
        </div>
        <div class="grow flex flex-col justify-between">
          <ul class="space-y-2 font-medium">
            <.sidebar_menu_item
              :for={menu_item <- Enum.at(@sidebar_menu, 0)}
              menu_item={menu_item}
              current_path={@current_path}
            />
          </ul>
          <div>
            <ul class="space-y-2 font-medium">
              <.sidebar_menu_item
                :for={menu_item <- Enum.at(@sidebar_menu, 1)}
                menu_item={menu_item}
                current_path={@current_path}
              />
            </ul>

            <%!-- Dropdown --%>
            <.sidebar_project_menu />
          </div>
        </div>
      </div>
    </aside>
    """
  end

  def main_header(assigns) do
    ~H"""
    <header class="sticky top-0 container max-w-7xl mx-auto z-30 dark:lg:shadow-none lg:backdrop-filter backdrop-blur bg-transparent dark:bg-gray-900 border-gray-200 dark:border-gray-700">
      <div class="px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16 -mb-px mx-auto container">
          <div class="flex min-w-[68px] gap-3">
            <button
              class="text-gray-500 hover:text-gray-600 lg:hidden"
              @click.stop="sidebarOpen = !sidebarOpen"
              aria-controls="sidebar"
              x-bind:aria-expanded="sidebarOpen"
              aria-expanded="false"
            >
              <span class="sr-only">
                Open sidebar
              </span>
              <svg class="w-6 h-6 fill-current" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <rect x="4" y="5" width="16" height="2"></rect>
                <rect x="4" y="11" width="16" height="2"></rect>
                <rect x="4" y="17" width="16" height="2"></rect>
              </svg>
            </button>
            <h1 class="font-medium text-xl">
              <%= render_slot(@title) %>
            </h1>
          </div>
          <div class="flex bg-indigo-500 hover:bg-indigo-500/90 rounded-lg items-center">
            <.global_new_menu />
          </div>
        </div>
      </div>
    </header>
    """
  end

  defp sidebar_backdrop(assigns) do
    ~H"""
    <div
      x-show="sidebarOpen"
      x-transition:enter="transition-opacity ease-linear duration-300"
      x-transition:enter-start="opacity-0"
      x-transition:enter-end="opacity-100"
      x-transition:leave="transition-opacity ease-linear duration-300"
      x-transition:leave-start="opacity-100"
      x-transition:leave-end="opacity-0"
      class="fixed inset-0 bg-gray-900/80"
      style="display: none;"
    >
    </div>
    """
  end

  defp global_new_menu(assigns) do
    ~H"""
    <.link
      navigate={~p"/"}
      class="w-full text-white font-medium py-1 px-2 pr-4 inline-flex items-center  gap-2"
    >
      <.iconify icon="ri:add-line" class="w-6 h-6 text-base-content" />
      <span>New email</span>
    </.link>
    """
  end

  defp sidebar_project_menu(assigns) do
    ~H"""
    <div phx-click-away={JS.hide(to: "#profile-menu")} class="relative">
      <button
        phx-click={JS.toggle(to: "#profile-menu")}
        class="w-full relative flex items-center h-12 py-2 px-8 text-sm font-medium transition-colors  text-neutral-700 hover:cursor-pointer focus:outline-none disabled:opacity-50 disabled:pointer-events-none"
      >
        <img
          src="https://cdn.devdojo.com/images/may2023/adam.jpeg"
          class="object-cover w-8 h-8 border rounded-full border-neutral-200"
        />
        <span class="self-center flex items-center h-full ml-2 text-base leading-none">
          Yasoob Khalid
        </span>
        <.iconify
          icon="ri:expand-up-down-line"
          class="w-5 h-5 absolute right-0 text-base-content mr-3"
        />
      </button>
      <div
        id="profile-menu"
        class="absolute bottom-full z-150 w-56 mt-12 -translate-x-1/2 left-1/2 hidden"
      >
        <div class="p-1 mt-1 bg-white border rounded-md shadow-md border-neutral-200/70 text-neutral-700">
          <a
            href="#"
            class="relative flex font-bold text-indigo-500 cursor-default select-none hover:bg-neutral-100 items-center rounded px-2 py-1.5 text-sm outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50 hover:cursor-pointer"
          >
            <%!-- <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4 mr-2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg> --%>
            <div class="relative flex items-center justify-center w-6 h-6 mr-2 overflow-hidden bg-indigo-800 rounded-full dark:bg-gray-600">
              <span class="font-bold text-white dark:text-gray-300">N</span>
            </div>
            <span>Python Tips</span>
            <span class="ml-auto text-xs tracking-widest opacity-60">
              <%!-- <.svg name="check" class="w-4 h-4" /> --%>
            </span>
          </a>
          <a
            href="#"
            class="relative flex cursor-default select-none hover:bg-neutral-100 items-center rounded px-2 py-1.5 text-sm outline-none transition-colors data-[disabled]:pointer-events-none data-[disabled]:opacity-50 hover:cursor-pointer"
          >
            <.iconify icon="ri:add-line" class="w-5 h-5 mr-2 text-base-content" />
            <span>New Newsletter</span>
          </a>
          <div class="h-px my-1 -mx-1 bg-neutral-200"></div>
          <button
            phx-click={JS.dispatch("toogle-darkmode")}
            class="relative w-full flex cursor-default select-none hover:bg-neutral-100 items-center rounded px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 hover:cursor-pointer"
          >
            <.iconify icon="ri:contrast-2-line" class="w-5 h-5 mr-2 text-base-content" />
            <span>Toggle darkmode</span>
          </button>
          <a
            href="/sign-out"
            class="relative flex cursor-default select-none hover:bg-neutral-100 items-center rounded px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 hover:cursor-pointer"
          >
            <.iconify icon="ri:logout-circle-line" class="w-5 h-5 mr-2 text-base-content" />
            <span>Log out</span>
          </a>
        </div>
      </div>
    </div>
    """
  end

  defp sidebar_menu_item(assigns) do
    ~H"""
    <li>
      <.link
        navigate={@menu_item.path}
        class={"#{if @menu_item.path == @current_path, do: "border-indigo-500 text-indigo-500 dark:text-white dark:border-white", else: "text-slate-700 dark:text-white"} flex items-center p-2 px-4   hover:text-indigo-500 dark:hover:bg-gray-700 border-s-4 dark:border-transparent "}
      >
        <.iconify icon={@menu_item.icon} class="w-6 h-6 text-base-content" />
        <span class="ml-3"><%= @menu_item.label %></span>
      </.link>
    </li>
    """
  end
end
