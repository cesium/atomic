defmodule AtomicWeb.Components.Empty do
  @moduledoc false
  use AtomicWeb, :component

  def empty_state(
        %{
          url: url,
          placeholder: placeholder,
          icon: icon
        } = assigns
      ) do
    ~H"""
    <div class="h-screen flex items-center justify-center">
      <div class="flex flex-col items-center justify-center text-center lg:w-1/2 rounded-lg border-2 p-12 border-dashed border-orange-300 hover:border-orange-400 focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2">
        <Heroicons.Outline.render icon={icon} class="h-10" />
        <h3 class="mt-2 text-sm font-semibold text-gray-900">No <%= placeholder %>s</h3>
        <p class="mt-1 text-sm text-gray-500">Get started by creating a new <%= placeholder %>.</p>
        <div class="mt-6">
          <%= live_redirect to: url, class: "inline-flex items-center rounded-md bg-orange-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-orange-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600" do %>
            <svg class="-ml-0.5 mr-1.5 h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z" />
            </svg>
            New <%= placeholder %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
