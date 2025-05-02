defmodule AtomicWeb.Components.ImageUploader do
  @moduledoc """
  An image uploader component that allows you to upload an image.
  """

  use AtomicWeb, :component

  attr :id, :string, default: "image-uploader"
  attr :upload, :any
  attr :class, :string, default: ""
  attr :image_class, :string, default: ""
  attr :image, :string, default: nil
  attr :icon, :string, default: "hero-photo"
  attr :preview_disabled, :boolean, default: false
  attr :rounded, :boolean, default: false
  attr :editable, :boolean, default: true
  attr :memory_unit, :string, default: "MB"

  slot :placeholder, required: false, doc: "Slot for the placeholder content."

  def image_uploader(assigns) do
    assigns = update(assigns, %{})

    ~H"""
    <div id={@id}>
      <%= if @editable do %>
        <.live_file_input upload={@upload} class="hidden" />
      <% end %>
      <section
        phx-drop-target={@upload.ref}
        class={[
          "hover:cursor-pointer",
          @rounded && "rounded-full overflow-hidden",
          not @rounded && "rounded-xl",
          @class
        ]}
        onclick={"document.getElementById('#{@upload.ref}').click()"}
      >
        <%= if @upload.entries == [] do %>
          <article class="h-full">
            <figure class="flex h-full items-center justify-center">
              <%= if @image do %>
                <img class={[@rounded && "p-0", not @rounded, @image_class]} src={@image} />
              <% else %>
                <%= if @placeholder do %>
                  <div class="flex flex-col items-center gap-2">
                    {render_slot(@placeholder)}
                    <p class="text-xs text-gray-500">
                      {extensions_to_string(@upload.accept)}<br /> up to {@size_file} {@memory_unit}
                    </p>
                  </div>
                <% else %>
                  <div class="flex select-none flex-col items-center gap-2">
                    <.icon name={@icon} class="h-12 w-12" />
                    <p class="px-4 text-center">{gettext("Upload a file or drag and drop.")}</p>
                  </div>
                <% end %>
              <% end %>
            </figure>
          </article>
        <% end %>
        <%= if !@preview_disabled do %>
          <%= for entry <- @upload.entries do %>
            <article class="h-full">
              <figure class="flex h-full items-center justify-center">
                <%= if entry.ref do %>
                  <.live_img_preview id={"preview-#{entry.ref}"} class={[@rounded && "p-0", not @rounded && "p-4", @image_class]} entry={entry} />
                <% else %>
                  <div class="flex select-none flex-col items-center gap-2">
                    <.icon name="hero-document" class="h-12 w-12" />
                    <p class="px-4 text-center">{entry.client_name}</p>
                  </div>
                <% end %>
              </figure>
              <%= for err <- upload_errors(@upload, entry) do %>
                <p class="alert alert-danger text-red-500">{Phoenix.Naming.humanize(err)}</p>
              <% end %>
            </article>
          <% end %>
        <% end %>
        <%= for err <- upload_errors(@upload) do %>
          <p class="alert alert-danger text-red-500">{Phoenix.Naming.humanize(err)}</p>
        <% end %>
      </section>
    </div>
    """
  end

  def update(assigns, _socket) do
    max_size =
      if Map.has_key?(assigns, :upload) do
        assigns.upload.max_file_size
      else
        0
      end

    memory_unit = assigns[:memory_unit]

    size_file = convert_size(max_size, memory_unit)

    assigns
    |> Map.put(:size_file, size_file)
  end

  defp convert_size(size_in_bytes, memory_unit) do
    size_in_bytes_float = size_in_bytes * 1.0

    case memory_unit do
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
