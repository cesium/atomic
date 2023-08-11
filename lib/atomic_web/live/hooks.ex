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

  def on_mount(:current_user_state, _params, session, socket) do
    current_user = maybe_get_current_user(session)
    default_organization = maybe_get_default_organization(current_user)
    socket = socket |> assign(:time_zone, get_timezone(socket))

    case current_user do
      nil ->
        {:cont, socket |> assign(:current_user, nil) |> assign(:current_organization, nil)}

      _ ->
        {:cont,
         socket
         |> assign(:current_user, current_user)
         |> assign(:current_organization, default_organization)}
    end
  end

  def on_mount(:current_user, _params, _session, socket) do
    {:cont, socket}
  end

  # Returns the current user if the user token exists, otherwise `nil`.
  defp maybe_get_current_user(session) do
    case session["user_token"] do
      nil ->
        nil

      user_token ->
        Accounts.get_user_by_session_token(user_token)
    end
  end

  # Returns the default organization for the current user if the user exists, otherwise `nil`.
  defp maybe_get_default_organization(current_user) do
    case current_user do
      nil ->
        nil

      _ ->
        Organizations.get_organization!(current_user.default_organization_id)
    end
  end

  # Returns the timezone for the application.
  defp get_timezone(socket) do
    owner = Application.get_env(:atomic, :owner)
    get_connect_params(socket)["timezone"] || owner.time_zone
  end
end
