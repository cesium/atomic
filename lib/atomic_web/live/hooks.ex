defmodule AtomicWeb.Hooks do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  alias Atomic.Accounts
  alias Atomic.Organizations

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, :page_title, "Atomic")}
  end

  def on_mount(:authenticated_user_state, params, %{"user_token" => user_token, "current_organization" => current_organization}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)

    if params["organization_id"] != nil && params["organization_id"] != current_organization.id do
      socket =
        socket
        |> assign(:current_user, current_user)
        |> assign(:current_organization, Organizations.get_organization!(params["organization_id"]))

      {:cont, socket}
    else
      socket =
        socket
        |> assign(:current_user, current_user)
        |> assign(:current_organization, current_organization)

      {:cont, socket}
    end
  end

  def on_mount(:general_user_state, _params, session, socket) do
    current_organization = session["current_organization"]
    if current_organization do
      {:cont, socket |> assign(:current_organization, current_organization)}
    else
      {:cont, socket}
    end
  end

  def on_mount(:current_user, _params, _session, socket) do
    {:cont, socket}
  end
end
