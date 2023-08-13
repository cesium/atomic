defmodule AtomicWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias Atomic.Organizations
  alias AtomicWeb.Router.Helpers, as: Routes

  def pages(conn, current_organization, current_user) do
    if current_organization != nil do
      if current_user.role in [:admin] or
           Organizations.get_role(current_user.id, current_organization.id) in [:admin, :owner] do
        admin_pages(conn, current_organization)
      else
      end
    else
      user_pages(conn)
    end
  end

  def default_pages(conn) do
    [
      %{
        key: :organizations,
        title: "Organizations",
        icon: :office_building,
        url: Routes.organization_index_path(conn, :index),
        tabs: []
      }
    ]
  end

  def admin_pages(conn, current_organization) do
    [
      %{
        key: :home,
        title: "Home",
        icon: :home,
        url: Routes.home_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :calendar,
        title: "Calendar",
        icon: :calendar,
        url: Routes.calendar_show_path(conn, :show),
        tabs: []
      },
      %{
        key: :activities,
        title: "Activities",
        icon: :academic_cap,
        url: Routes.activity_index_path(conn, :index, current_organization.id),
        tabs: []
      },
      %{
        key: :departments,
        title: "Departments",
        icon: :cube,
        url: Routes.department_index_path(conn, :index, current_organization.id),
        tabs: []
      },
      %{
        key: :partners,
        title: "Partners",
        icon: :user_group,
        url: Routes.partner_index_path(conn, :index, current_organization.id),
        tabs: []
      },
      %{
        key: :memberships,
        title: "Memberships",
        icon: :user_add,
        url: Routes.membership_index_path(conn, :index, current_organization.id),
        tabs: []
      },
      %{
        key: :board,
        title: "Board",
        icon: :users,
        url: Routes.board_index_path(conn, :index, current_organization.id),
        tabs: []
      },
      %{
        key: :organizations,
        title: "Organizations",
        icon: :office_building,
        url: Routes.organization_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :scanner,
        title: "Scanner",
        icon: :qrcode,
        url: Routes.scanner_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :profile,
        title: "Settings",
        icon: :cog,
        url: Routes.user_settings_path(conn, :edit),
        tabs: []
      }
    ]
  end

  def user_pages(conn) do
    [
      %{
        key: :home,
        title: "Home",
        icon: :home,
        url: Routes.home_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :calendar,
        title: "Calendar",
        icon: :calendar,
        url: Routes.calendar_show_path(conn, :show),
        tabs: []
      },
      %{
        key: :activities,
        title: "Activities",
        icon: :academic_cap,
        url: Routes.activity_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :organizations,
        title: "Organizations",
        icon: :office_building,
        url: Routes.organization_index_path(conn, :index),
        tabs: []
      }
    ]
  end
end
