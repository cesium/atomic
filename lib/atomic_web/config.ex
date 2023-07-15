defmodule AtomicWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias AtomicWeb.Router.Helpers, as: Routes

  def pages(conn) do
    [
      %{
        key: :activities,
        title: "Home",
        icon: :home,
        url: Routes.activity_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :calendar,
        title: "Calendar",
        icon: :calendar,
        url: "",
        tabs: []
      },
      %{
        key: :departments,
        title: "Departments",
        icon: :cube,
        url: Routes.department_index_path(conn, :index, :org),
        tabs: []
      },
      %{
        key: :instructors,
        title: "Activities",
        icon: :academic_cap,
        url: Routes.activity_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :partners,
        title: "Partners",
        icon: :user_group,
        url: Routes.partner_index_path(conn, :index),
        tabs: []
      },
      %{
        key: :memberships,
        title: "Memberships",
        icon: :user_add,
        url: Routes.membership_index_path(conn, :index, :org),
        tabs: []
      },
      %{
        key: :board,
        title: "Board",
        icon: :users,
        url: Routes.board_index_path(conn, :index, :org),
        tabs: []
      },
      %{
        key: :scanner,
        title: "Scanner",
        icon: :qrcode,
        url: Routes.scanner_index_path(conn, :index),
        tabs: []
      }
    ]
  end
end
