defmodule AtomicWeb.ActivityLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities
  alias Atomic.Activities.Activity
  alias Atomic.Departments

  @extensions_whitelist ~w(.jpg .jpeg .gif .png)

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:image, accept: @extensions_whitelist, max_entries: 1)}
  end

  @impl true
  def update(%{activity: activity} = assigns, socket) do
    current_organization = assigns.current_organization
    departments = Departments.list_departments_by_organization_id(current_organization.id)
    speakers = Activities.list_speakers_by_organization_id(current_organization.id)

    changeset = Activities.change_activity(%Activity{departments: departments})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:departments, load_options(departments))
     |> assign(:selected_departments, [])
     |> assign(:speakers, speakers)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity" => activity_params}, socket) do
    changeset =
      socket.assigns.activity
      |> Activities.change_activity(activity_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("toggle_option", %{"id" => id}, socket) do
    updated_departments =
      Enum.map(socket.assigns.departments, fn option ->
        if option.id == id do
          %{option | selected: !option.selected}
        else
          option
        end
      end)

    {:noreply,
     socket
     |> assign(:departments, updated_departments)
     |> assign(:selected_departments, Enum.filter(updated_departments, & &1.selected))}
  end

  @impl true
  def handle_event("save", %{"activity" => activity_params}, socket) do
    options =
      List.foldl(socket.assigns.departments, [], fn option, acc ->
        if option.selected do
          [option.id | acc]
        else
          acc
        end
      end)

    activity_params =
      activity_params
      |> Map.put("departments", options)

    save_activity(socket, socket.assigns.action, activity_params)
  end

  defp save_activity(socket, :edit, activity_params) do
    case Activities.update_activity(socket.assigns.activity, activity_params) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_activity(socket, :new, activity_params) do
    case Activities.create_activity(activity_params) do
      {:ok, _activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Activity created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp load_options(items) do
    Enum.map(items, fn item ->
      %{
        id: item.id,
        label: item.name,
        selected: false
      }
    end)
  end
end
