defmodule AtomicWeb.Components.ImageUploader do
  @moduledoc """
  An image uploader component that allows you to upload an image.
  """

  use AtomicWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <div class="shrink-0 1.5xl:shrink-0">
        <.live_file_input upload={@upload} class="hidden" />
        <div class={
            "#{if length(@upload.entries) != 0 do
              "hidden"
            end} #{@class} border-2 border-gray-300 border-dashed rounded-md"
          } phx-drop-target={@upload.ref}>
          <div class="flex h-full items-center justify-center px-6">
            <div class="flex flex-col items-center justify-center space-y-1">
              <.icon name={@icon} class="size-8 text-zinc-400" />
              <div class="flex flex-col items-center text-sm text-zinc-600">
                <label for="file-upload" class="relative cursor-pointer rounded-md font-medium text-orange-500 hover:text-red-800">
                  <a onclick={"document.getElementById('#{@upload.ref}').click()"}>Upload a file</a>
                </label>
                <p class="pl-1">or drag and drop</p>
              </div>
              <p class="text-xs text-gray-500">
                <%= extensions_to_string(@upload.accept) %> up to <%= assigns.size_file %> <%= @type %>
              </p>
            </div>
          </div>
        </div>
        <section>
          <%= for entry <- @upload.entries do %>
            <%= for err <- upload_errors(@upload, entry) do %>
              <div class="alert alert-danger relative rounded border border-red-400 bg-red-100 px-4 py-3 text-red-700" role="alert">
                <span class="block sm:inline"><%= Phoenix.Naming.humanize(err) %></span>
                <span class="absolute top-0 right-0 bottom-0 px-4 py-3">
                  <title>Close</title>
                </span>
              </div>
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

  def update(assigns, socket) do
    max_size = assigns.upload.max_file_size
    type = assigns[:type]

    size_file = convert_size(max_size, type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:size_file, size_file)}
  end

  defp convert_size(size_in_bytes, type) do
    size_in_bytes_float = size_in_bytes * 1.0

    case type do
      "kB" -> Float.round(size_in_bytes_float / 1_000, 2)
      "MB" -> Float.round(size_in_bytes_float / 1_000_000, 2)
      "GB" -> Float.round(size_in_bytes_float / 1_000_000_000, 2)
      "TB" -> Float.round(size_in_bytes_float / 1_000_000_000_000, 2)
      _ -> size_in_bytes_float
    end
  end

  def extensions_to_string(extensions) do
    extensions
    |> String.split(",")
    |> Enum.map_join(", ", fn ext -> String.trim_leading(ext, ".") |> String.upcase() end)
  end
end
