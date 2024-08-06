defmodule AtomicWeb.Router do
  use AtomicWeb, :router

  import AtomicWeb.UserAuth
  import PhoenixStorybook.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AtomicWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # Authorization pipelines

  pipeline :admin do
    plug AtomicWeb.Plugs.Authorize, :admin
  end

  pipeline :master do
    plug AtomicWeb.Plugs.Authorize, :master
  end

  # Association verification pipelines

  pipeline :confirm_activity_association do
    plug AtomicWeb.Plugs.VerifyAssociation, &Atomic.Activities.get_activity!/1
  end

  pipeline :confirm_announcement_association do
    plug AtomicWeb.Plugs.VerifyAssociation, &Atomic.Organizations.get_announcement!/1
  end

  pipeline :confirm_department_association do
    plug AtomicWeb.Plugs.VerifyAssociation, &Atomic.Departments.get_department!/1
  end

  pipeline :confirm_partner_association do
    plug AtomicWeb.Plugs.VerifyAssociation, &Atomic.Partners.get_partner!/1
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
        scope "/activities" do
          pipe_through :confirm_activity_association
          live "/new", ActivityLive.New, :new
          live "/:id/edit", ActivityLive.Edit, :edit
        end

        scope "/announcements" do
          pipe_through :confirm_announcement_association
          live "/new", AnnouncementLive.New, :new
          live "/:id/edit", AnnouncementLive.Edit, :edit
        end

        scope "/departments" do
          pipe_through :confirm_department_association
          live "/new", DepartmentLive.Edit, :new
          live "/:id/edit", DepartmentLive.Edit, :edit
          live "/:id/collaborators/:collaborator_id/edit", DepartmentLive.Show, :edit_collaborator
        end

        scope "/partners" do
          pipe_through :confirm_partner_association
          live "/new", PartnerLive.Edit, :new
          live "/:id/edit", PartnerLive.Edit, :edit
        end
      end
    end
  end

  ## Normal user routes

  scope "/", AtomicWeb do
    pipe_through :browser

    live_session :user, on_mount: [{AtomicWeb.Hooks, :current_user_state}] do
      live "/", HomeLive.Index, :index
      live "/calendar", CalendarLive.Show, :show
      live "/activities", ActivityLive.Index, :index
      live "/organizations", OrganizationLive.Index, :index
      live "/announcements", AnnouncementLive.Index, :index

      live "/activities/:id", ActivityLive.Show, :show
      live "/announcements/:id", AnnouncementLive.Show, :show

      live "/profile/:slug", ProfileLive.Show, :show

      pipe_through [
        :require_authenticated_user,
        :require_confirmed_user,
        :require_finished_user_setup
      ]

      live "/profile/:slug/edit", ProfileLive.Edit, :edit

      live "/scanner", ScannerLive.Index, :index

      get "/users/change_password", UserChangePasswordController, :edit
      put "/users/change_password", UserChangePasswordController, :update

      live "/users/confirm_email/:token", ProfileLive.Edit, :confirm_email

      scope "/organizations/:organization_id" do
        scope "/departments" do
          pipe_through :confirm_department_association
          live "/", DepartmentLive.Index, :index
          live "/:id", DepartmentLive.Show, :show
        end

        scope "/partners" do
          pipe_through :confirm_partner_association
          live "/", PartnerLive.Index, :index
          live "/:id", PartnerLive.Show, :show
        end
      end
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
    pipe_through [
      :browser,
      :require_authenticated_user,
      :redirect_if_user_has_finished_account_setup
    ]

    get "/users/setup", UserSetupController, :edit
    put "/users/setup", UserSetupController, :finish
  end

  scope "/", AtomicWeb do
    pipe_through :browser

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

  # Enables the Storybook components collection in development.
  #
  # Check the PhoenixStorybook documentation for more information.
  if Mix.env() == :dev do
    scope "/" do
      storybook_assets()
    end

    scope "/", AtomicWeb do
      pipe_through :browser

      live_storybook("/storybook", backend_module: AtomicWeb.Storybook)
    end
  end

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
