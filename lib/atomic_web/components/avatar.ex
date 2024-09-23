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
    default: :light_gray,
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
    <span class={generate_avatar_classes(assigns)}>
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

  attr :items, :list, required: true, doc: "The list of avatars to display."

  attr :spacing, :integer,
    default: -1,
    values: [-3, -2, -1, 0, 1, 2, 3],
    doc: "The spacing between avatars."

  attr :type, :atom,
    values: [:user, :organization, :company],
    default: :user,
    doc: "The type of entity associated with the avatars."

  attr :size, :atom,
    values: [:xs, :sm, :md, :lg, :xl],
    default: :md,
    doc: "The size of the avatars."

  attr :color, :atom,
    default: :light_gray,
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
    doc: "Avatar color."

  attr :wrap, :boolean, default: false, doc: "Whether to wrap the avatars in a flex container."

  attr :class, :string, default: "", doc: "Additional classes to apply to the component."

  attr :avatar_class, :string,
    default: "",
    doc: "Additional classes to apply to the individual avatars."

  def avatar_group(assigns) do
    ~H"""
    <ul class={"#{generate_avatar_group_spacing_class(@spacing)} #{if @wrap do "flex-wrap" end} #{@class} flex flex-row"}>
      <%= for item <- @items do %>
        <li>
          <.avatar name={item[:name]} src={item[:src]} type={@type} size={@size} color={@color} class={"#{@avatar_class} atomic-avatar-grouped"} auto_generate_initials={Map.get(item, :auto_generate_initials, true)} />
        </li>
      <% end %>
    </ul>
    """
  end

  defp generate_avatar_classes(assigns) do
    [
      "atomic-avatar",
      assigns.src && "atomic-avatar--src",
      "atomic-avatar--#{assigns.color}",
      "atomic-avatar--#{assigns.size}",
      "atomic-avatar--#{assigns.type}",
      assigns.class
    ]
  end

  defp generate_avatar_group_spacing_class(spacing) do
    %{
      -3 => "-space-x-3",
      -2 => "-space-x-2",
      -1 => "-space-x-1",
      0 => "space-x-0",
      1 => "space-x-1",
      2 => "space-x-2",
      3 => "space-x-3"
    }[spacing]
  end
end
