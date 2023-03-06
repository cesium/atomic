defmodule AtomicWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias AtomicWeb.Router.Helpers, as: Routes

  @conn AtomicWeb.Endpoint

  def user_pages() do
    base_pages()
  end

  def admin_pages() do
    adm_pages()
  end

  defp base_pages do
    [
      %{
        key: :activities,
        title: "Activities",
        url: Routes.activity_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :department,
        title: "Departments",
        url: Routes.department_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :partners,
        title: "Partners",
        url: Routes.partner_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :speakers,
        title: "Speakers",
        url: Routes.speaker_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :organizations,
        title: "Organizations",
        url: Routes.organization_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :products,
        title: "Products",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :orders,
        title: "Orders",
        url: Routes.order_index_path(@conn, :index),
        tabs: []
      }
    ]
  end

  defp adm_pages() do
    [
      %{
        key: :activities,
        title: "Activities",
        url: Routes.activity_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :departments,
        title: "Departments",
        url: Routes.department_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :partners,
        title: "Partners",
        url: Routes.partner_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :speakers,
        title: "Speakers",
        url: Routes.speaker_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :organizations,
        title: "Organizations",
        url: Routes.organization_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :dashboard,
        title: "Dashboard",
        url: Routes.admin_dashboard_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :products,
        title: "Products",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :orders,
        title: "Orders",
        url: Routes.admin_order_index_path(@conn, :index),
        tabs: []
      }
    ]
  end
end
