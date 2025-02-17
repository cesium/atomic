defmodule AtomicWeb.Components.ImageUploader do
  @moduledoc """
  An image uploader component that allows you to upload an image.
  The component attributes are:
    @uploads - the uploads object
    @target - the target to send the event to

  The component events the parent component should define are:
    cancel-image - cancels the upload of an image. This event should be defined in the component that you passed in the @target attribute.
  """
  use AtomicWeb, :live_component
  attr :icon, :string, default: "hero-photo"

  def render(assigns) do
    ~H"""
    <div class="h-full">
      <.live_file_input upload={@uploads.image} class="hidden" />
      <div class="h-full shrink-0 1.5xl:shrink-0">
        <section class={if @uploads.image.entries == [] && !@image, do: "h-full", else: ""} phx-drop-target={@uploads.image.ref} onclick={"document.getElementById('#{@uploads.image.ref}').click()"}>
          <%= if @uploads.image.entries == [] do %>
            <%= if @image do %>
              <div class="flex flex-col place-items-center">
                <img class="p-4" src={@image} />
                <span class="cursor-pointer text-sm text-orange-500 hover:text-red-800">Click to upload new image</span>
                <p class="text-xs text-zinc-500">(PNG, JPG, GIF up to 10MB)</p>
              </div>
            <% else %>
              <article class="h-full w-full">
                <figure class="flex h-full items-center justify-center">
                  <div class="flex h-full w-full place-items-center rounded-md border-2 border-dashed border-zinc-300">
                    <div class="mx-auto flex h-full place-items-center justify-center sm:col-span-6 lg:w-full">
                      <div class="my-[140px] flex justify-center px-6">
                        <div class="space-y-1 text-center">
                          <svg class="size-12 mx-auto text-zinc-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                            <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                          </svg>
                          <div class="flex text-sm text-zinc-600">
                            <span class="rounded-md font-medium text-orange-500">Upload a file</span>
                            <p class="pl-1">or drag and drop</p>
                          </div>
                          <p class="text-xs text-zinc-500">
                            PNG, JPG, GIF up to 10MB
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </figure>
              </article>
            <% end %>
          <% end %>
        </section>
        <%= if @uploads.image.entries do %>
          <%= for entry <- @uploads.image.entries do %>
            <%= for err <- upload_errors(@uploads.image, entry) do %>
              <div class="flex justify-center">
                <p class="alert alert-danger text-orange-500"><%= Phoenix.Naming.humanize(err) %></p>
              </div>
            <% end %>
            <article class="upload-entry">
              <figure class="">
                <.live_img_preview entry={entry} />
                <div class="flex">
                  <figcaption>
                    <%= if String.length(entry.client_name) < 30 do %>
                      <% entry.client_name %>
                    <% else %>
                      <% String.slice(entry.client_name, 0..30) <> "... " %>
                    <% end %>
                  </figcaption>
                  <button type="button" phx-click="cancel-image" phx-target={@target} phx-value-ref={entry.ref} aria-label="cancel" class="pl-4">
                    <.icon name="hero-x-mark-solid" class="size-5 text-zinc-400" />
                  </button>
                </div>
              </figure>
            </article>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end
end
