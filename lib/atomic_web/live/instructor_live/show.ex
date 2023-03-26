defmodule AtomicWeb.InstructorLive.Show do
  use AtomicWeb, :live_view

  alias Atomic.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    instructor = Activities.get_instructor!(id)

    entries = [
      %{
        name: gettext("Instructors"),
        route: Routes.instructor_index_path(socket, :index)
      },
      %{
        name: instructor.name,
        route: Routes.instructor_show_path(socket, :show, instructor)
      },
    ]

    {:noreply,
     socket
     |> assign(:current_page, :instructors)
     |> assign(:breadcrumb_entries, entries)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:instructor, instructor)}
  end

  defp page_title(:show), do: "Show Instructor"
  defp page_title(:edit), do: "Edit Instructor"
end
