defmodule AtomicWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  use AtomicWeb, :verified_routes

  alias Atomic.Accounts

  # User is not logged in
  def pages(nil, _current_organization) do
    default_pages()
  end

  # User is logged in
  def pages(current_user, current_organization) do
    if has_permissions?(current_user, current_organization) do
      admin_pages(current_organization)
    else
      user_pages()
    end
  end

  def user_pages do
    default_pages() ++
      [
        %{
          key: :scanner,
          title: "Scanner",
          icon: "hero-qr-code",
          icon_selected: "hero-qr-code-solid",
          url: ~p"/scanner",
          tabs: []
        }
      ]
  end

  def admin_pages(current_organization) do
    default_pages() ++
      [
        %{
          key: :departments,
          title: "Departments",
          icon: "hero-cube",
          icon_selected: "hero-cube-solid",
          url: ~p"/organizations/#{current_organization}/departments",
          tabs: []
        },
        %{
          key: :announcements,
          title: "Announcements",
          icon: "hero-newspaper",
          icon_selected: "hero-newspaper-solid",
          url: ~p"/organizations/#{current_organization}/announcements",
          tabs: []
        },
        %{
          key: :partners,
          title: "Partners",
          icon: "hero-user-group",
          icon_selected: "hero-user-group-solid",
          url: ~p"/organizations/#{current_organization}/partners",
          tabs: []
        },
        %{
          key: :scanner,
          title: "Scanner",
          icon: "hero-qr-code",
          icon_selected: "hero-qr-code-solid",
          url: ~p"/scanner",
          tabs: []
        }
      ]
  end

  def default_pages do
    [
      %{
        key: :home,
        title: "Home",
        icon: "hero-home",
        icon_selected: "hero-home-solid",
        url: ~p"/",
        tabs: []
      },
      %{
        key: :calendar,
        title: "Calendar",
        icon: "hero-calendar",
        icon_selected: "hero-calendar-solid",
        url: ~p"/calendar",
        tabs: []
      },
      %{
        key: :activities,
        title: "Activities",
        icon: "hero-academic-cap",
        icon_selected: "hero-academic-cap-solid",
        url: ~p"/activities",
        tabs: []
      },
      %{
        key: :organizations,
        title: "Organizations",
        icon: "tabler-affiliate",
        icon_selected: "tabler-affiliate-filled",
        url: ~p"/organizations",
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
