defmodule AtomicWeb.Router do
  use AtomicWeb, :router

  import AtomicWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AtomicWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug AtomicWeb.Plugs.Authorize, :admin
  end

  pipeline :member do
    plug AtomicWeb.Plugs.Authorize, :member
  end

  pipeline :follower do
    plug AtomicWeb.Plugs.Authorize, :follower
  end

  scope "/", AtomicWeb do
    pipe_through [
      :browser,
      :require_authenticated_user,
      :require_confirmed_user,
      :require_finished_user_setup
    ]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    delete "/users/log_out", UserSessionController, :delete

    live_session :logged_in, on_mount: [{AtomicWeb.Hooks, :authenticated_user_state}] do
      live "/", HomeLive.Index, :index
      live "/scanner", ScannerLive.Index, :index
      live "/calendar", CalendarLive.Show, :show

      scope "/organizations/:organization_id" do
        pipe_through :admin
        live "/edit", OrganizationLive.Index, :edit
        live "/show/edit", OrganizationLive.Show, :edit

        live "/activities/new", ActivityLive.New, :new
        live "/activities/:id/edit", ActivityLive.Edit, :edit

        live "/departments/new", DepartmentLive.Index, :new
        live "/departments/:id/edit", DepartmentLive.Index, :edit
        live "/departments/:id/show/edit", DepartmentLive.Show, :edit

        live "/partners/new", PartnerLive.Index, :new
        live "/partners/:id/edit", PartnerLive.Index, :edit
        live "/partners/:id/show/edit", PartnerLive.Show, :edit

        live "/speakers/new", SpeakerLive.Index, :new
        live "/speakers/:id/edit", SpeakerLive.Index, :edit
        live "/speakers/:id/show/edit", SpeakerLive.Show, :edit

        live "/board/new", BoardLive.New, :new
        live "/board/:id/edit", BoardLive.Edit, :edit

        live "/memberships", MembershipLive.Index, :index
        live "/memberships/new", MembershipLive.New, :new
        live "/memberships/:id", MembershipLive.Show, :show
        live "/memberships/:id/edit", MembershipLive.Edit, :edit

        live "/news/new", NewsLive.New, :new
        live "/news/:id/edit", NewsLive.Edit, :edit
      end

      scope "/organizations/:organization_id" do
        pipe_through :follower
        live "/activities", ActivityLive.Index, :index
        live "/activities/:id", ActivityLive.Show, :show

        live "/departments", DepartmentLive.Index, :index
        live "/departments/:id", DepartmentLive.Show, :show

        live "/partners", PartnerLive.Index, :index
        live "/partners/:id", PartnerLive.Show, :show

        live "/speakers", SpeakerLive.Index, :index
        live "/speakers/:id", SpeakerLive.Show, :show

        live "/news", NewsLive.Index, :index
        live "/news/:id", NewsLive.Show, :show
      end

      live "/organizations/new", OrganizationLive.Index, :new

      live "/user/edit", UserLive.Edit, :edit

      pipe_through :member
      live "/card/:membership_id", CardLive.Show, :show
    end
  end

  scope "/", AtomicWeb do
    pipe_through :browser

    live_session :general, on_mount: [{AtomicWeb.Hooks, :general_user_state}] do
      live "/organizations", OrganizationLive.Index, :index
      live "/organizations/:organization_id", OrganizationLive.Show, :show

      live "/profile/:handle", UserLive.Show, :show

      scope "/organizations/:organization_id" do
        live "/board/", BoardLive.Index, :index
        live "/board/:id", BoardLive.Show, :show
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AtomicWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AtomicWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", AtomicWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", AtomicWeb do
    pipe_through [:browser, :require_authenticated_user]
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", AtomicWeb do
    pipe_through [
      :browser,
      :require_authenticated_user,
      :redirect_if_user_has_finished_account_setup
    ]

    get "/users/setup", UserSetupController, :edit
    put "/users/setup", UserSetupController, :finish
  end

  scope "/", AtomicWeb do
    pipe_through [:browser]

    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
