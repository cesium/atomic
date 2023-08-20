defmodule AtomicWeb.NewsLive.FormComponent do
  use AtomicWeb, :live_component

  alias Atomic.Organizations

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(%{news: news} = assigns, socket) do
    changeset = Organizations.change_news(news)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"news" => news_params}, socket) do
    changeset =
      socket.assigns.news
      |> Organizations.change_news(news_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"news" => news_params}, socket) do
    save_news(socket, socket.assigns.action, news_params)
  end

  defp save_news(socket, :edit, news_params) do
    case Organizations.update_news(
           socket.assigns.news,
           news_params
         ) do
      {:ok, _news} ->
        {:noreply,
         socket
         |> put_flash(:success, "News updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_news(socket, :news, news_params) do
    news_params = Map.put(news_params, "organization_id", socket.assigns.organization.id)

    case Organizations.create_news(news_params) do
      {:ok, _news} ->
        {:noreply,
         socket
         |> put_flash(:success, "News created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
