defmodule AtomicWeb.OrganizationLive.CertificateLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Organizations
  alias Atomic.Certificate
  import AtomicWeb.Components.Forms

  @impl true
  def mount(_params, _session, socket) do
    certificate_options = %{
      background: true,
      title: 62,
      content: "Para os devidos efeitos, certifica-se que participou na atividade",
      background_color: "#ffffff",
      title_color: "#fb923c",
      content_color: "#000000",
      organization_color: "#000000"
    }

    {:ok, assign(socket, certificate_options: certificate_options)}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id} = params, _url, socket) do
    activities = list_activities(organization_id)
    organization = Organizations.get_organization!(organization_id)
    IO.inspect(organization_id, label: "Organization_id")

    default_options = %{
      background: true,
      title: 62,
      content: "Para os devidos efeitos, certifica-se que participou na atividade",
      background_color: "#ffffff",
      title_color: "#fb923c",
      content_color: "#000000",
      organization_color: "#000000"
    }

    certificate_options = default_options

    changeset = Certificate.changeset(%Certificate{}, %{
      organization_id: organization_id,
      background: default_options.background,
      title: default_options.title,
      content: default_options.content,
      background_color: default_options.background_color,
      title_color: default_options.title_color,
      content_color: default_options.content_color,
      organization_color: default_options.organization_color
    })

    certificate = %Certificate{}

    {:noreply,
     socket
     |> assign(:page_title, gettext("Certificate"))
     |> assign(:current_page, :certificate)
     |> assign(:changeset, changeset)
     |> assign(:certificate, certificate)
     |> assign(:activities, activities)
     |> assign(:organization, organization)
     |> assign(:certificate_options, certificate_options)
     |> assign(:params, params)}
  end

  @impl true
  def handle_event("validate", %{"certificate" => certificate_params}, socket) do
    certificate_options = extract_certificate_options(certificate_params)

    changeset =
      (socket.assigns.certificate || %Certificate{})
      |> Certificate.changeset(Map.put(certificate_params, "organization_id", socket.assigns.organization.id))
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:certificate_options, certificate_options)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    organization_id = socket.assigns.organization.id
    certificate_params = %{
      "organization_id" => organization_id,
      "background" => socket.assigns.certificate_options.background,
      "title" => socket.assigns.certificate_options.title,
      "content" => socket.assigns.certificate_options.content,
      "background_color" => socket.assigns.certificate_options.background_color,
      "title_color" => socket.assigns.certificate_options.title_color,
      "content_color" => socket.assigns.certificate_options.content_color,
      "organization_color" => socket.assigns.certificate_options.organization_color
    }

    case %Certificate{} |> Certificate.changeset(certificate_params) |> Atomic.Repo.insert() do
      {:ok, certificate} ->
        case Organizations.update_organization(socket.assigns.organization, %{certificate_template_id: socket.assigns.certificate.id}) |> IO.inspect() do
          {:ok, _organization} ->
            {:noreply, socket |> put_flash(:info, "Certificate saved and organization updated successfully!")}

          {:error, %Ecto.Changeset{} = changeset} ->
            IO.inspect(changeset.errors, label: "Organization update errors")
            {:noreply, socket |> put_flash(:error, "Certificate saved, but failed to update organization")}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset.errors, label: "Certificate errors")
        {:noreply, socket |> assign(:changeset, changeset) |> put_flash(:error, "Error saving certificate")}
    end
  end


  defp list_activities(organization_id) do
    case Activities.list_activities_by_organization_id(organization_id) do
      {:ok, {activities, _meta}} -> activities
      {:error, _flop} -> []
    end
  end

  defp extract_certificate_options(params) do
    %{
      background: Map.get(params, "background") == "true",
      title: parse_integer(Map.get(params, "title"), 62),
      content: Map.get(params, "content") || "Para os devidos efeitos, certifica-se que participou na atividade",
      background_color: Map.get(params, "background_color") || "#ffffff",
      title_color: Map.get(params, "title_color") || "#fb923c",
      content_color: Map.get(params, "content_color") || "#000000",
      organization_color: Map.get(params, "organization_color") || "#000000"
    }
  end

  defp parse_integer(value, default) when is_binary(value) do
    case Integer.parse(value) do
      {int, _} -> int
      :error -> default
    end
  end

  defp parse_integer(_, default), do: default
end
