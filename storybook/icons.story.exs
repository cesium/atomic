defmodule Storybook.Icons do
  use PhoenixStorybook.Story, :page

  import AtomicWeb.Components.Icon

  def doc, do: "Icons available to use in the application."

  def render(assigns) do
    ~H"""
    <div>
      <div class="grid grid-cols-[repeat(auto-fill,minmax(8rem,1fr))] gap-x-6 gap-y-4 pb-16 pt-10 sm:pt-11 md:pt-12">
        <%= for {name, _} <- Heroicons.__info__(:functions) |> Enum.drop(2) do %>
          <div class="text-center">
            <div onclick={"navigator.clipboard.writeText(':#{name}');"} title={"Click to copy :#{name}"} class="flex flex-col items-center justify-center rounded-lg border px-4 py-6 text-center hover:cursor-pointer hover:bg-gray-50">
              <span class="block h-12 w-12">
                <.icon name={name} />
              </span>
              <p class="mx-2 max-w-full truncate py-2 text-xs text-gray-500">:<%= name %></p>
            </div>
            <p class="py-2 text-sm"><%= name |> to_string() |> String.replace("_", " ") |> String.capitalize() %></p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
