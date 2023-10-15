defmodule DaakiaWeb.Router do
  use DaakiaWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DaakiaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", DaakiaWeb do
    pipe_through :browser

    # get "/", PageController, :home

    ash_authentication_live_session :authentication_required,
      on_mount: [{DaakiaWeb.LiveUserAuth, :live_user_required}, DaakiaWeb.RouteAssigns] do
      live "/", HomeLive, :index
      live "/campaigns", EmailsLive, :index
    end

    # Ash auth
    sign_in_route(
      on_mount: [{DaakiaWeb.LiveUserAuth, :live_no_user}],
      register_path: "/register",
      reset_path: "/password-reset"
    )

    sign_out_route AuthController
    auth_routes_for Daakia.Accounts.User, to: AuthController
    reset_route []
  end

  # Other scopes may use custom stacks.
  # scope "/api", DaakiaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:daakia, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DaakiaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
