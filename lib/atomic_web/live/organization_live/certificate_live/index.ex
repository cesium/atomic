defmodule AtomicWeb.OrganizationLive.CertificateLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Organizations
  import Atomic.Quantum.CertificateDelivery
  import AtomicWeb.Components.Forms

  @impl true
  def mount(_params, _session, socket) do
    certificate_options = %{
      background: true,
      title: 62,
      content: "Para os devidos efeitos, certifica-se que participou na atividade",
      organization: true,
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
    changeset = Organizations.change_organization(organization)

    {:noreply,
     socket
     |> assign(:page_title, gettext("Certificate"))
     |> assign(:current_page, :certificate)
     |> assign(:organization, organization)
     |> assign(:changeset, changeset)
     |> assign(:activities, activities)
     |> assign(:params, params)}
  end

  @impl true
  def handle_event("validate", %{"organization" => organization_params}, socket) do
    certificate_options = extract_certificate_options(organization_params)

    changeset =
      socket.assigns.organization
      |> Organizations.change_organization(organization_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:certificate_options, certificate_options)}
  end

  @impl true
  def handle_event("generate", _params, socket) do
    if Map.has_key?(socket.assigns, :activity) and
         Map.has_key?(socket.assigns, :organization) and
         Map.has_key?(socket.assigns, :enrollment) do
      case generate_certificate(
             socket.assigns.enrollment,
             socket.assigns.activity,
             socket.assigns.organization,
             socket.assigns.certificate_options
           ) do
        {:ok, _pdf_path} ->
          {:noreply, socket |> put_flash(:info, "Certificado gerado com sucesso!")}

        {:error, reason} ->
          {:noreply, socket |> put_flash(:error, "Erro ao gerar certificado: #{reason}")}
      end
    else
      {:noreply, socket |> put_flash(:error, "Dados insuficientes para gerar o certificado.")}
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
      background: Map.get(params, "Background") == "true",
      title: parse_integer(Map.get(params, "title"), 62),
      content: Map.get(params, "content") || "Para os devidos efeitos, certifica-se que participou na atividade",
      organization: Map.get(params, "organization") == "true",
      background_color: Map.get(params, "Background_color") || "#ffffff",
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
