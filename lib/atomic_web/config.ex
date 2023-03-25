defmodule AtomicWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias AtomicWeb.Router.Helpers, as: Routes

  def pages(conn) do
    [
      %{
        key: :activities,
        title: "Activities",
        icon: :academic_cap,
        url: Routes.activity_index_path(conn, :index),
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
        key: :instructors,
        title: "Instructors",
        icon: :user,
        url: Routes.speaker_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :organizations,
        title: "Organizations",
        icon: :user_group,
        url: Routes.organization_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :users,
        title: "Users",
        icon: :users,
        url: Routes.user_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :departments,
        title: "Departments",
        icon: :briefcase,
        url: Routes.department_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :partnerships,
        title: "Partnerships",
        icon: :speakerphone,
        url: Routes.partner_index_path(conn, :index),
        tabs: []
      }
    ]
  end
end
