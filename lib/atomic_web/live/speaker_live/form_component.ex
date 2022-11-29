defmodule AtomicWeb.SpeakerLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Activities

  @impl true
  def update(%{speaker: speaker} = assigns, socket) do
    changeset = Activities.change_speaker(speaker)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"speaker" => speaker_params}, socket) do
    changeset =
      socket.assigns.speaker
      |> Activities.change_speaker(speaker_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"speaker" => speaker_params}, socket) do
    save_speaker(socket, socket.assigns.action, speaker_params)
  end

  defp save_speaker(socket, :edit, speaker_params) do
    case Activities.update_speaker(socket.assigns.speaker, speaker_params) do
      {:ok, _speaker} ->
        {:noreply,
         socket
         |> put_flash(:info, "Speaker updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_speaker(socket, :new, speaker_params) do
    case Activities.create_speaker(speaker_params) do
      {:ok, _speaker} ->
        {:noreply,
         socket
         |> put_flash(:info, "Speaker created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
