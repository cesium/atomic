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

  pipeline :auth_layout do
    plug :put_layout, {AtomicWeb.LayoutView, :auth}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AtomicWeb do
    pipe_through :browser
  end

  scope "/", AtomicWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :logged_in, on_mount: [{AtomicWeb.Hooks, :current_user}] do
      live "/", ActivityLive.Index, :index
      live "/activities", ActivityLive.Index, :index
      live "/activities/new", ActivityLive.New, :new
      live "/activities/:id/edit", ActivityLive.Edit, :edit
      live "/activities/:id", ActivityLive.Show, :show

      live "/calendar", CalendarLive.Show, :show

      live "/departments/:organization", DepartmentLive.Index, :index
      live "/departments/:organization/new", DepartmentLive.Index, :new
      live "/departments/:organization/:id/edit", DepartmentLive.Index, :edit
      live "/departments/:organization/:id", DepartmentLive.Show, :show
      live "/departments/:organization/:id/show/edit", DepartmentLive.Show, :edit

      live "/partners/:organization/", PartnerLive.Index, :index
      live "/partners/:organization/new", PartnerLive.Index, :new
      live "/partners/:organization/:id/edit", PartnerLive.Index, :edit
      live "/partners/:organization/:id", PartnerLive.Show, :show
      live "/partners/:organization/:id/show/edit", PartnerLive.Show, :edit

      live "/instructors", InstructorLive.Index, :index
      live "/instructors/new", InstructorLive.Index, :new
      live "/instructors/:id/edit", InstructorLive.Index, :edit
      live "/instructors/:id", InstructorLive.Show, :show
      live "/instructors/:id/show/edit", InstructorLive.Show, :edit

      live "/organizations", OrganizationLive.Index, :index
      live "/organizations/new", OrganizationLive.Index, :new
      live "/organizations/:id/edit", OrganizationLive.Index, :edit
      live "/organizations/:id", OrganizationLive.Show, :show
      live "/organizations/:id/show/edit", OrganizationLive.Show, :edit

      live "/users", UserLive.Index, :index
      live "/users/new", UserLive.Index, :new
      live "/users/:id/edit", UserLive.Index, :edit
      live "/users/:id", UserLive.Show, :show
      live "/users/:id/show/edit", UserLive.Show, :edit

      live "/memberships/:organization", MembershipLive.Index, :index
      live "/memberships/:organization/new", MembershipLive.New, :new
      live "/memberships/:organization/:id", MembershipLive.Show, :show
      live "/memberships/:organization/:id/edit", MembershipLive.Edit, :edit
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
    pipe_through [:browser, :auth_layout, :redirect_if_user_is_authenticated]

    scope "/auth" do
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

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", AtomicWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
