defmodule AtomicWeb.OrganizationLive.CertificateLive.Index do
  use AtomicWeb, :live_view

  alias Atomic.Activities
  alias Atomic.Organizations
  import Atomic.Quantum.CertificateDelivery
  import AtomicWeb.Components.Forms


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"organization_id" => organization_id} = params, _url, socket) do
    activities = list_activities(organization_id)
    organization = Organizations.get_organization!(organization_id)
    changeset = Organizations.change_organization(organization)


    {:noreply,
     socket
     |> assign(:page_title, gettext("Certeficate"))
     |> assign(:current_page, :certificate)
     |> assign(:organization, organization)
     |> assign(:changeset, changeset)
     |> assign(:activities, activities)
     |> assign(:params, params)}
  end

  @impl true
  def handle_event("generate",_params, socket) do
    %{
      enrollment: enrollment,
      activity: activity,
      organization: organization
    } = socket.assigns

    case generate_certificate(enrollment, activity, organization) do
      {:ok, _pdf_path} ->
        {:noreply, socket |> put_flash(:info, "Certificado gerado com sucesso!")}

      {:error, reason} ->
        {:noreply, socket |> put_flash(:error, "Erro ao gerar certificado: #{inspect(reason)}")}
    end
  end

  defp list_activities(organization_id) do
    case Activities.list_activities_by_organization_id(organization_id) do
      {:ok, {activities, meta}} ->
        %{activities: activities, meta: meta}

      {:error, flop} ->
        %{activities: [], meta: flop}
    end
  end
  end
