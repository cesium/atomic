defmodule AtomicWeb.InstructorLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Activities.Instructor

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :instructors, list_instructors())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    entries = [
      %{
        name: gettext("Instructors"),
        route: Routes.instructor_index_path(socket, :index)
      }
    ]

    {:noreply,
     socket
     |> assign(:current_page, :instructors)
     |> assign(:breadcrumb_entries, entries)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Instructor")
    |> assign(:instructor, Activities.get_instructor!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Instructor")
    |> assign(:instructor, %Instructor{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Instructors")
    |> assign(:instructor, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    instructor = Activities.get_instructor!(id)
    {:ok, _} = Activities.delete_instructor(instructor)

    {:noreply, assign(socket, :instructors, list_instructors())}
  end

  defp list_instructors do
    Activities.list_instructors()
  end
end
