defmodule AtomicWeb.Components.ImageUploader do
  @moduledoc """
  An image uploader component that allows you to upload an image.
  The component attributes are:
    @uploads - the uploads object
    @target - the target to send the event to
    @width - the width of the uploader area
    @height - the height of the uploader area
    @id - a unique identifier for this uploader instance

  The component events the parent component should define are:
    cancel-image - cancels the upload of an image. This event should be defined in the component that you passed in the @target attribute.
  """
  use AtomicWeb, :live_component

  def render(assigns) do
    # Generate a unique reference using the passed id
    unique_ref = assigns.id <> "_upload"

    ~H"""
    <div>
      <div class="shrink-0 1.5xl:shrink-0">
        <.live_file_input upload={@uploads.image} class="hidden" />
        <div class={
          "#{if length(@uploads.image.entries) != 0 do
              "hidden"
            end} #{@class} border-2 border-gray-300 border-dashed rounded-md"
          } phx-drop-target={unique_ref}>
          <div class="flex h-full items-center justify-center px-6">
            <div class="flex flex-col items-center justify-center space-y-1">
              <svg class="size-12 mx-auto text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
                <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
              </svg>
              <div class="flex flex-col items-center text-sm text-gray-600">
                <label for="file-upload" class="relative cursor-pointer rounded-md font-medium text-orange-500 hover:text-red-800">
                  <a onclick={"document.getElementById('#{unique_ref}').click()"}>Upload a file</a>
                </label>
                <p class="pl-1">or drag and drop</p>
              </div>
              <p class="text-xs text-gray-500">PNG, JPG, GIF up to 10MB</p>
            </div>
          </div>
        </div>
        <section>
          <%= for entry <- @uploads.image.entries do %>
            <%= for err <- upload_errors(@uploads.image, entry) do %>
              <p class="alert alert-danger"><%= Phoenix.Naming.humanize(err) %></p>
            <% end %>
            <article class="upload-entry">
              <figure class="w-[400px]">
                <.live_img_preview entry={entry} />
                <div class="flex">
                  <figcaption>
                    <%= if String.length(entry.client_name) < 30 do %>
                      <%= entry.client_name %>
                    <% else %>
                      <%= String.slice(entry.client_name, 0..30) <> "... " %>
                    <% end %>
                  </figcaption>
                  <button type="button" phx-click="cancel-image" phx-target={@target} phx-value-ref={entry.ref} aria-label="cancel" class="pl-4">
                    <.icon name="hero-x-mark-solid" class="size-5 text-gray-400" />
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
