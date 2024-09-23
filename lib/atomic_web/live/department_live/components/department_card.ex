defmodule AtomicWeb.DepartmentLive.Components.DepartmentCard do
  @moduledoc false
  use AtomicWeb, :component

  import AtomicWeb.Components.{Avatar, Badge, Gradient}

  attr :department, :map, required: true, doc: "The department to display."
  attr :collaborators, :list, required: true, doc: "The list of collaborators in the department."

  def department_card(assigns) do
    ~H"""
    <div class={["flex flex-col justify-center rounded-lg border border-zinc-200 hover:bg-zinc-50", @department.archived && "opacity-50"]}>
      <div class="h-14 w-full object-cover">
        <%= if @department.banner do %>
          <img class="h-14 w-full rounded-t-lg object-cover" src={Uploaders.Banner.url({@department.banner, @department}, :original)} />
        <% else %>
          <.gradient seed={@department.id} class="rounded-t-lg" />
        <% end %>
      </div>
      <div class="px-4 py-4">
        <div class="flex">
          <p class="text-lg font-semibold"><%= @department.name %></p>
          <.badge :if={@department.archived} variant={:outline} color={:warning} size={:md} class="bg-yellow-300/5 select-none rounded-xl border-yellow-400 py-1 font-normal text-yellow-400 sm:ml-auto sm:py-0">
            <p><%= gettext("Archived") %></p>
          </.badge>
        </div>
        <.avatar_group
          size={:xs}
          color={:light_gray}
          spacing={-2}
          class="min-h-8 mt-4 mb-2"
          items={
            @collaborators
            |> Enum.take(4)
            |> Enum.map(fn person ->
              %{
                name: person.user.name
              }
            end)
            |> then(fn avatars ->
              if length(@collaborators) > 4 do
                Enum.concat(avatars, [%{name: "+#{length(@collaborators) - 4}", auto_generate_initials: false}])
              else
                avatars
              end
            end)
          }
        />
      </div>
    </div>
    """
  end
end
