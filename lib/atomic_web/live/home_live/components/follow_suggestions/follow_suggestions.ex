defmodule AtomicWeb.HomeLive.Components.FollowSuggestions do
  @moduledoc false
  use AtomicWeb, :component

  alias __MODULE__.Suggestion

  attr :current_user, :map,
    required: true,
    doc: "The current user logged in."

  attr :organizations, :list,
    required: true,
    doc: "Organizations displayed as follow suggestions."

  def follow_suggestions(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <p class="font-semibold leading-6 text-zinc-400">
        <%= title(@current_user) %>
      </p>
      <div class="flow-root">
        <ul role="list" class="divide-y divide-gray-200">
          <%= for organization <- @organizations do %>
            <.live_component id={organization.id} module={Suggestion} organization={organization} current_user={@current_user} />
          <% end %>
        </ul>
      </div>
      <div class="mt-2 mb-4">
        <.button patch={Routes.organization_index_path(AtomicWeb.Endpoint, :index)} color={:white} size={:md} full_width>
          <%= gettext("View all") %>
        </.button>
      </div>
    </div>
    """
  end

  defp title(current_user) when is_nil(current_user), do: gettext("Top organizations")

  defp title(_current_user), do: gettext("Organizations you may like")
end
