defmodule AtomicWeb.Components.ImageUploader do
  @moduledoc """
  An image uploader component that allows you to upload an image.
  """

  use AtomicWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <div class="shrink-0 1.5xl:shrink-0">
        <.live_file_input upload={@uploads} class="hidden" />
        <div class={
            "#{if length(@uploads.entries) != 0 do
              "hidden"
            end} #{@class} border-2 border-gray-300 border-dashed rounded-md"
          } phx-drop-target={@uploads.ref}>
          <div class="flex h-full items-center justify-center px-6">
            <div class="flex flex-col items-center justify-center space-y-1">
              <.icon name={@icon} class="size-8 text-zinc-400" />
              <div class="flex flex-col items-center text-sm text-zinc-600">
                <label for="file-upload" class="relative cursor-pointer rounded-md font-medium text-orange-500 hover:text-red-800">
                  <a onclick={"document.getElementById('#{@uploads.ref}').click()"}>Upload a file</a>
                </label>
                <p class="pl-1">or drag and drop</p>
              </div>
              <p class="text-xs text-gray-500">
                <%= @uploads.accept
                |> String.split(",")
                |> Enum.map(&String.trim_leading(&1, "."))
                |> Enum.map(&String.upcase/1)
                |> Enum.join(", ") %> up to <%= @size_file %>
              </p>
            </div>
          </div>
        </div>
        <section>
          <%= for entry <- @uploads.entries do %>
            <%= for err <- upload_errors(@uploads, entry) do %>
              <p class="alert alert-danger"><%= Phoenix.Naming.humanize(err) %></p>
            <% end %>
            <article class="upload-entry">
              <figure class="w-[100px]">
                <.live_img_preview entry={entry} id={"preview-#{entry.ref}"} class="rounded-lg shadow-lg" />
                <div class="flex">
                  <figcaption>
                    <%= if String.length(entry.client_name) < 30 do %>
                      <%= entry.client_name %>
                    <% else %>
                      <%= String.slice(entry.client_name, 0..30) <> "... " %>
                    <% end %>
                  </figcaption>
                  <button type="button" phx-click="cancel-image" phx-target={@target} phx-value-ref={entry.ref} aria-label="cancel" class="pl-4">
                    <.icon name="hero-x-mark-solid" class="size-5 text-zinc-400" />
                  </button>
                </div>
              </figure>
            </article>
          <% end %>
        </section>
      </div>
    </div>
    """
  end
end
