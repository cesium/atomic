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

  def on_mount(
        :authenticated_user_state,
        _params,
        session,
        socket
      ) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    owner = Application.get_env(:atomic, :owner)
    time_zone = get_connect_params(socket)["timezone"] || owner.time_zone

    if current_user.default_organization_id != nil do
      socket =
        socket
        |> assign(:current_user, current_user)
        |> assign(
          :current_organization,
          Organizations.get_organization!(current_user.default_organization_id)
        )
        |> assign(:time_zone, time_zone)

      {:cont, socket}
    else
      socket =
        socket
        |> assign(:current_user, current_user)
        |> assign(:time_zone, time_zone)

      {:cont, socket}
    end
  end

  def on_mount(:general_user_state, _params, session, socket) do
    current_organization = session["current_organization"]
    current_user = session["user_token"]
    owner = Application.get_env(:atomic, :owner)
    time_zone = get_connect_params(socket)["timezone"] || owner.time_zone

    case {current_organization, current_user} do
      {nil, nil} ->
        {:cont, socket}

      {nil, _} ->
        user = Accounts.get_user_by_session_token(current_user)

        {:cont,
         socket
         |> assign(:current_user, user)
         |> assign(
           :current_organization,
           Organizations.get_organization!(user.default_organization_id)
         )
         |> assign(:time_zone, time_zone)}

      {_, nil} ->
        {:cont,
         socket
         |> assign(:current_organization, current_organization)}

      {organization, _} ->
        user = Accounts.get_user_by_session_token(current_user)

        {:cont,
         socket
         |> assign(:current_user, user)
         |> assign(
           :current_organization,
           organization
         )
         |> assign(:time_zone, time_zone)}
    end
  end

  def on_mount(:current_user, _params, _session, socket) do
    {:cont, socket}
  end
end
