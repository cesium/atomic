defmodule AtomicWeb.Components.Map do
  @moduledoc """
  A configurable component to display a map using Google Maps.
  """
  use Phoenix.Component

  attr :location, :string, required: true, doc: "The location to be displayed on the map"
  attr :zoom, :integer, default: 16, doc: "The zoom level of the map"

  attr :type, :atom,
    values: [:normal, :satellite],
    default: :normal,
    doc: "The view type of the map"

  attr :height, :integer, default: 200, doc: "The height of the map"
  attr :width, :integer, doc: "The width of the map"

  attr :full_width, :boolean,
    default: true,
    doc: "If true, the map will take up the full width of its container"

  attr :controls, :boolean,
    default: false,
    doc: "If true, the map will be interactive and show controls"

  def map(assigns) do
    if assigns[:controls] do
      map_interactive(assigns)
    else
      map_static(assigns)
    end
  end

  defp map_static(assigns) do
    ~H"""
    <.link href={"https://www.google.com/maps/search/?api=1&query=#{@location}"} target="_blank" class="select-none overflow-hidden" style={"height: #{@height}px; width: #{generate_width(assigns)}"}>
      <iframe width={generate_width(assigns)} height={@height + 300} src={generate_request(assigns)} frameborder="0" scrolling="no" marginheight="0" marginwidth="0" style="border:0; margin-top: -150px;" class="pointer-events-none"></iframe>
    </.link>
    """
  end

  defp map_interactive(assigns) do
    ~H"""
    <iframe width={generate_width(assigns)} height={@height} src={generate_request(assigns)} frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
    """
  end

  defp generate_request(assigns) do
    location = assigns[:location]
    zoom = assigns[:zoom]
    type = assigns[:type]

    "https://maps.google.com/maps?q=#{location}&t=#{type_request_value(type)}&z=#{zoom}&output=embed"
  end

  defp generate_width(assigns) do
    if assigns[:full_width] && !assigns[:width], do: "100%", else: "#{assigns[:width]}px"
  end

  defp type_request_value(:normal), do: "m"
  defp type_request_value(:satellite), do: "k"
end
