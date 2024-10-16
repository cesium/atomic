defmodule AtomicWeb.PartnerLive.Edit do
  use AtomicWeb, :live_view

  alias Atomic.Organizations.Partner
  alias Atomic.Partners
  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"id" => partner_id} = _params,
        _,
        %{:assigns => %{:live_action => :edit}} = socket
      ) do
    partner = Partners.get_partner!(partner_id)

    {:noreply,
     socket
     |> assign(:page_title, partner.name)
     |> assign(:action, nil)
     |> assign(:partner, partner)
     |> assign(:current_page, :partners)}
  end

  @impl true
  def handle_params(_params, _, %{:assigns => %{:live_action => :new}} = socket) do
    {:noreply,
     socket
     |> assign(:page_title, "New Partner")
     |> assign(:action, nil)
     |> assign(:partner, %Partner{organization_id: socket.assigns.current_organization.id})
     |> assign(:current_page, :partners)}
  end

  @impl true
  def handle_event("set-action", %{"action" => action}, socket) do
    {:noreply, assign(socket, :action, action |> String.to_atom())}
  end

  @impl true
  def handle_event("clear-action", _params, socket) do
    {:noreply, assign(socket, :action, nil)}
  end

  @impl true
  def handle_event("confirm-action", _params, %{assigns: %{action: :delete}} = socket) do
    partner = socket.assigns.partner
    organization_id = partner.organization_id

    case Partners.delete_partner(partner) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:success, "Partner deleted successfully")
         |> push_navigate(to: ~p"/organizations/#{organization_id}/partners")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete partner")}
    end
  end

  @impl true
  def handle_event("confirm-action", _params, %{assigns: %{action: :archive}} = socket) do
    partner = socket.assigns.partner
    organization_id = partner.organization_id

    case Partners.archive_partner(partner) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:success, "Partner archived successfully")
         |> push_navigate(to: ~p"/organizations/#{organization_id}/partners")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete partner")}
    end
  end

  def handle_event("confirm-action", _params, %{assigns: %{action: :unarchive}} = socket) do
    partner = socket.assigns.partner
    organization_id = partner.organization_id

    case Partners.unarchive_partner(partner) do
      {:ok, _partner} ->
        {:noreply,
         socket
         |> put_flash(:success, "Partner unarchived successfully")
         |> push_navigate(to: ~p"/organizations/#{organization_id}/partners")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Failed to delete partner")}
    end
  end

  defp display_action_goal_confirm_title(action) do
    case action do
      :archive ->
        gettext("Are you sure you want to archive this partner?")

      :unarchive ->
        gettext("Are you sure you want to unarchive this partner?")

      :delete ->
        gettext("Are you sure you want do delete this partner?")
    end
  end

  defp display_action_goal_confirm_description(action, partner) do
    case action do
      :archive ->
        gettext("You can always change you mind later and make it public again.")

      :unarchive ->
        gettext("This will make it so that any person can view this partner.")

      :delete ->
        gettext(
          "This will permanently delete %{partner_name}, this action is not reversible.",
          partner_name: partner.name
        )
    end
  end
end
