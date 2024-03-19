defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  import AtomicWeb.Components.Field

  @impl true
  def mount(socket) do
    {:ok, socket}
  end
end
