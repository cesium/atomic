defmodule AtomicWeb.OrganizationLive.Components.DepartmentsGrid do
  @moduledoc """
  Internal organization-related component for displaying its departments.
  """
  use AtomicWeb, :component

  alias Atomic.Departments
  alias Atomic.Organizations.{Department, Organization}

  # FIXME: This should be a shared component
  import AtomicWeb.DepartmentLive.Components.DepartmentCard

  attr :organization, Organization,
    required: true,
    doc: "the organization which departments to display"

  def departments_grid(assigns) do
    ~H"""
    <div id="organization-departments" class="grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-2">
      <%= for department <- list_departments(@organization) do %>
        <.link navigate={Routes.department_show_path(AtomicWeb.Endpoint, :show, @organization, department)}>
          <.department_card department={department} collaborators={list_department_collaborators(department)} />
        </.link>
      <% end %>
    </div>
    """
  end

  defp list_departments(%Organization{} = organization) do
    Departments.list_departments_by_organization_id(organization.id,
      preloads: [:organization],
      where: [archived: false]
    )
  end

  defp list_department_collaborators(%Department{} = department) do
    Departments.list_department_collaborators(department.id,
      preloads: [:user],
      where: [accepted: true]
    )
  end
end
