defmodule AtomicWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias Atomic.Accounts
  alias AtomicWeb.Router.Helpers, as: Routes

  # User is not logged in
  def pages(conn, nil, _current_organization) do
    default_pages(conn)
  end

  # User is logged in
  def pages(conn, current_user, current_organization) do
    if has_permissions?(current_user, current_organization) do
      admin_pages(conn, current_organization)
    else
      user_pages(conn)
    end
  end

  def user_pages(conn) do
    default_pages(conn) ++
      [
        %{
          key: :scanner,
          title: "Scanner",
          icon: "hero-qr-code",
          url: Routes.scanner_index_path(conn, :index),
          tabs: []
        }
      ]
  end

  def admin_pages(conn, current_organization) do
    default_pages(conn) ++
      [
        %{
          key: :departments,
          title: "Departments",
          icon: "hero-cube",
          url: Routes.department_index_path(conn, :index, current_organization.id),
          tabs: []
        },
        %{
          key: :partners,
          title: "Partners",
          icon: "tabler-heart-handshake",
          url: Routes.partner_index_path(conn, :index, current_organization.id),
          tabs: []
        },
        %{
          key: :scanner,
          title: "Scanner",
          icon: "hero-qr-code",
          url: Routes.scanner_index_path(conn, :index),
          tabs: []
        }
      ]
  end

  def default_pages(conn) do
    [
      %{
        key: :home,
        title: "Home",
        icon: "hero-home",
        url: Routes.home_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :calendar,
        title: "Calendar",
        icon: "hero-calendar",
        url: Routes.calendar_show_path(conn, :show),
        tabs: []
      },
      %{
        key: :activities,
        title: "Activities",
        icon: "hero-academic-cap",
        url: Routes.activity_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :announcements,
        title: "Announcements",
        icon: "hero-newspaper",
        url: Routes.announcement_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :organizations,
        title: "Organizations",
        icon: "tabler-affiliate",
        url: Routes.organization_index_path(conn, :index),
        tabs: []
      }
    ]
  end

  # Returns true if the user has permissions to access the organization admin pages
  defp has_permissions?(_current_user, nil), do: false

  defp has_permissions?(current_user, current_organization) do
    Accounts.has_master_permissions?(current_user.id) ||
      Accounts.has_permissions_inside_organization?(
        current_user.id,
        current_organization.id
      )
  end
end
