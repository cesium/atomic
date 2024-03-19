defmodule AtomicWeb.DepartmentLive.Components.DepartmentCard do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar
  import AtomicWeb.DepartmentLive.Components.DepartmentBannerPlaceholder

  attr :department, :map, required: true, doc: "The department to display."
  attr :collaborators, :list, required: true, doc: "The list of collaborators in the department."

  def department_card(assigns) do
    ~H"""
    <div class="flex flex-col justify-center rounded-lg border border-zinc-200 hover:bg-zinc-50">
      <div class="h-14 w-full object-cover">
        <.department_banner_placeholder department={@department} class="rounded-t-lg" />
      </div>
      <div class="px-4 py-4">
        <p class="text-lg font-semibold"><%= @department.name %></p>
        <div class="min-h-8 mt-4 mb-2 flex flex-row -space-x-1">
          <%= for person <- @collaborators |> Enum.take(4) do %>
            <.avatar name={person.user.name} size={:xs} color={:light_gray} class="ring-1 ring-white" />
          <% end %>
          <%= if length(@collaborators) > 4 do %>
            <.avatar name={"+#{length(@collaborators) - 4}"} size={:xs} auto_generate_initials={false} color={:light_gray} class="ring-1 ring-white" />
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
