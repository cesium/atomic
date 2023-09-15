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

  pipeline :master do
    plug AtomicWeb.Plugs.Authorize, :master
  end

  ## Admin routes
  scope "/", AtomicWeb do
    pipe_through [
      :browser,
      :require_authenticated_user,
      :require_confirmed_user,
      :require_finished_user_setup,
      :admin
    ]

    live_session :admin, on_mount: [{AtomicWeb.Hooks, :current_user_state}] do
      scope "/organizations/:organization_id" do
        live "/edit", OrganizationLive.Edit, :edit

        live "/activities/new", ActivityLive.New, :new
        live "/activities/:id/edit", ActivityLive.Edit, :edit

        live "/announcements/new", AnnouncementLive.New, :new
        live "/announcements/:id/edit", AnnouncementLive.Edit, :edit

        live "/departments/new", DepartmentLive.New, :new
        live "/departments/:id/edit", DepartmentLive.Index, :edit

        live "/partners/new", PartnerLive.New, :new
        live "/partners/:id/edit", PartnerLive.Index, :edit

        live "/speakers/new", SpeakerLive.New, :new
        live "/speakers/:id/edit", SpeakerLive.Edit, :edit

        live "/board/new", BoardLive.New, :new
        live "/board/:id/edit", BoardLive.Edit, :edit

        live "/memberships", MembershipLive.Index, :index
        live "/memberships/new", MembershipLive.New, :new
        live "/memberships/:id", MembershipLive.Show, :show
        live "/memberships/:id/edit", MembershipLive.Edit, :edit
      end
    end
  end

  ## Normal user routes
  scope "/", AtomicWeb do
    pipe_through [:browser]

    live_session :user, on_mount: [{AtomicWeb.Hooks, :current_user_state}] do
      live "/", HomeLive.Index, :index
      live "/calendar", CalendarLive.Show, :show
      live "/activities", ActivityLive.Index, :index
      live "/organizations", OrganizationLive.Index, :index
      live "/announcements", AnnouncementLive.Index, :index

      live "/activities/:id", ActivityLive.Show, :show
      live "/organizations/:organization_id", OrganizationLive.Show, :show
      live "/announcements/:id", AnnouncementLive.Show, :show

      live "/profile/:slug", ProfileLive.Show, :show
      live "/profile/:slug/edit", ProfileLive.Edit, :edit

      pipe_through [
        :require_authenticated_user,
        :require_confirmed_user,
        :require_finished_user_setup
      ]

      live "/scanner", ScannerLive.Index, :index

      get "/users/settings", UserSettingsController, :edit
      put "/users/settings", UserSettingsController, :update

      live "/users/confirm_email/:token", ProfileLive.Edit, :confirm_email

      scope "/organizations/:organization_id" do
        live "/departments", DepartmentLive.Index, :index

        live "/departments/:id", DepartmentLive.Show, :show

        live "/board/", BoardLive.Index, :index
        live "/board/:id", BoardLive.Show, :show

        live "/partners", PartnerLive.Index, :index
        live "/partners/:id", PartnerLive.Show, :show

        live "/speakers", SpeakerLive.Index, :index
        live "/speakers/:id", SpeakerLive.Show, :show
      end

      pipe_through [:member]
      live "/card/:membership_id", CardLive.Show, :show

      # Only masters can create organizations
      pipe_through [:master]
      live "/organizations/new", OrganizationLive.New, :new
    end
  end

  ## Authentication routes
  scope "/", AtomicWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    scope "/users" do
      get "/register", UserRegistrationController, :new
      post "/register", UserRegistrationController, :create
      get "/log_in", UserSessionController, :new
      post "/log_in", UserSessionController, :create
      get "/reset_password", UserResetPasswordController, :new
      post "/reset_password", UserResetPasswordController, :create
      get "/reset_password/:token", UserResetPasswordController, :edit
      put "/reset_password/:token", UserResetPasswordController, :update
    end
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

    scope "/users" do
      delete "/log_out", UserSessionController, :delete
      get "/confirm", UserConfirmationController, :new
      post "/confirm", UserConfirmationController, :create
      get "/confirm/:token", UserConfirmationController, :edit
      post "/confirm/:token", UserConfirmationController, :update
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
end
