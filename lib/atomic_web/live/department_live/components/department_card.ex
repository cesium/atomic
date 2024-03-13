defmodule AtomicWeb.DepartmentLive.Components.DepartmentCard do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar

  attr :department, :map, required: true, doc: "The department to display."
  attr :collaborators, :list, required: true, doc: "The list of collaborators in the department."

  def department_card(assigns) do
    ~H"""
    <div class="grid grid-cols-2 grid-rows-1 items-center justify-center space-x-4 rounded-lg border border-zinc-200 hover:bg-zinc-50">
      <div class="p-4">
        <p class="text-lg font-semibold"><%= @department.name %></p>
        <div class="mt-4 mb-2 grid grid-cols-7 gap-2">
          <%= for person <- @collaborators |> Enum.take(4) do %>
            <.avatar name={person.user.name} size={:xs} color={:light_gray} class="ring-1 ring-white" />
          <% end %>
          <%= if length(@collaborators) > 4 do %>
            <.avatar name={"+#{length(@collaborators) - 4}"} size={:xs} auto_generate_initials={false} color={:light_gray} class="ring-1 ring-white" />
          <% end %>
        </div>
      </div>
      <div>
        <img class="h-36 w-full rounded-r-lg object-cover" src={"https://github.com/identicons/#{@department.name |> String.slice(0..3)}.png"} />
      </div>
    </div>
    """
  end
end
