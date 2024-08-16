defmodule AtomicWeb.Components.Avatar do
  @moduledoc false
  use AtomicWeb, :component

  attr :src, :string, default: nil, doc: "The URL of the image to display."

  attr :name, :string, required: true, doc: "The name of the entity associated with the avatar."

  attr :auto_generate_initials, :boolean,
    default: true,
    doc: "Whether to automatically generate the initials from the name."

  attr :type, :atom,
    values: [:user, :organization, :company],
    default: :user,
    doc: "The type of entity associated with the avatar."

  attr :size, :atom,
    values: [:xs, :sm, :md, :lg, :xl],
    default: :md,
    doc: "The size of the avatar."

  attr :color, :atom,
    default: :primary,
    values: [
      :primary,
      :secondary,
      :info,
      :success,
      :warning,
      :danger,
      :gray,
      :light_gray,
      :pure_white,
      :white,
      :light,
      :dark
    ],
    doc: "Background color of the avatar."

  attr :class, :string, default: "", doc: "Additional classes to apply to the component."

  def avatar(assigns) do
    ~H"""
    <span class={generate_classes(assigns)}>
      <%= if @src do %>
        <img src={@src} class={"atomic-avatar--#{assigns.type} h-full w-full"} />
      <% else %>
        <%= if @auto_generate_initials do %>
          <%= extract_initials(@name) %>
        <% else %>
          <%= @name %>
        <% end %>
      <% end %>
    </span>
    """
  end

  defp generate_classes(assigns) do
    [
      "atomic-avatar",
      assigns.src && "atomic-avatar--src",
      "atomic-avatar--#{assigns.color}",
      "atomic-avatar--#{assigns.size}",
      "atomic-avatar--#{assigns.type}",
      assigns.class
    ]
  end
end
