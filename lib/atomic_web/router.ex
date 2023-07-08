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

  scope "/", AtomicWeb do
    pipe_through :browser

    live "/", ActivityLive.Index, :index
  end

  scope "/", AtomicWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :logged_in, on_mount: [{AtomicWeb.Hooks, :current_user}] do
      live "/scanner", ScannerLive.Index, :index

      live "/activities", ActivityLive.Index, :index
      live "/activities/new", ActivityLive.New, :new
      live "/activities/:id/edit", ActivityLive.Edit, :edit
      live "/activities/:id", ActivityLive.Show, :show

      live "/organizations/:organization_id/departments", DepartmentLive.Index, :index
      live "/organizations/:organization_id/departments/new", DepartmentLive.Index, :new
      live "/organizations/:organization_id/departments/:id/edit", DepartmentLive.Index, :edit
      live "/organizations/:organization_id/departments/:id", DepartmentLive.Show, :show
      live "/organizations/:organization_id/departments/:id/show/edit", DepartmentLive.Show, :edit

      live "/partners", PartnerLive.Index, :index
      live "/partners/new", PartnerLive.Index, :new
      live "/partners/:id/edit", PartnerLive.Index, :edit
      live "/partners/:id", PartnerLive.Show, :show
      live "/partners/:id/show/edit", PartnerLive.Show, :edit

      live "/speakers", SpeakerLive.Index, :index
      live "/speakers/new", SpeakerLive.Index, :new
      live "/speakers/:id/edit", SpeakerLive.Index, :edit
      live "/speakers/:id", SpeakerLive.Show, :show
      live "/speakers/:id/show/edit", SpeakerLive.Show, :edit

      live "/organizations", OrganizationLive.Index, :index
      live "/organizations/new", OrganizationLive.Index, :new
      live "/organizations/:id/edit", OrganizationLive.Index, :edit
      live "/organizations/:id", OrganizationLive.Show, :show
      live "/organizations/:id/show/edit", OrganizationLive.Show, :edit

      live "/membership/:org", MembershipLive.Index, :index
      live "/membership/:org/new", MembershipLive.New, :new
      live "/membership/:org/:id", MembershipLive.Show, :show
      live "/membership/:org/:id/edit", MembershipLive.Edit, :edit

      live "/card/:membership_id", CardLive.Show, :show

      live "/board/:org", BoardLive.Index, :index
      live "/board/:org/new", BoardLive.New, :new
      live "/board/:org/:id", BoardLive.Show, :show
      live "/board/:org/:id/edit", BoardLive.Edit, :edit
      live "/memberships/:org", MembershipLive.Index, :index
      live "/memberships/:org/new", MembershipLive.New, :new
      live "/memberships/:org/:id", MembershipLive.Show, :show
      live "/memberships/:org/:id/edit", MembershipLive.Edit, :edit

      live "/user/edit", UserLive.Edit, :edit
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
