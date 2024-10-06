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
        <.live_file_input upload={@uploads[@upload_name]} class="hidden" id={unique_ref <> "_file"} />
          <section>
            <%= for entry <- @uploads[@upload_name].entries do %>
              <%= for err <- upload_errors(@uploads[@upload_name], entry) do %>
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
