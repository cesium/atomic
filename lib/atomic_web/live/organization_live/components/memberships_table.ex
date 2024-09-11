defmodule AtomicWeb.OrganizationLive.Components.MembershipsTable do
  @moduledoc """
  Internal organization-related component for displaying its memberships in the form of a table.
  """
  use AtomicWeb, :component

  import AtomicWeb.Components.Avatar

  attr :members, :list, required: true, doc: "the list of memberships to display"

  # TODO: Make use of table component
  def memberships_table(assigns) do
    ~H"""
    <div class="mt-8 flow-root">
      <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
          <table class="min-w-full divide-y divide-gray-300">
            <thead>
              <tr>
                <th scope="col" class="py-3 pr-3 pl-4 text-left text-xs font-medium uppercase tracking-wide text-gray-500 sm:pl-0"><%= gettext("Name") %></th>
                <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500"><%= gettext("Role") %></th>
                <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500"><%= gettext("Joined At") %></th>
              </tr>
            </thead>

            <tbody class="divide-y divide-gray-200 bg-white">
              <tr :for={member <- @members} class="hover:cursor-pointer hover:bg-gray-50" phx-click={row_click(member)}>
                <td class="whitespace-nowrap py-5 pr-3 pl-4 text-sm sm:pl-0">
                  <div class="flex items-center">
                    <.avatar name={member.user.name} size={:sm} color={:light_gray} class="ring-1 ring-white" />
                    <div class="ml-4">
                      <div class="font-medium text-gray-900"><%= member.user.name %></div>
                      <div class="mt-1 text-gray-500"><%= member.user.email %></div>
                    </div>
                  </div>
                </td>
                <td class="whitespace-nowrap px-3 py-5 text-sm text-gray-900"><%= capitalize_first_letter(member.role) %></td>
                <td class="whitespace-nowrap px-3 py-5 text-sm text-gray-500"><%= relative_datetime(member.inserted_at) %></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  defp row_click(member) do
    Routes.profile_show_path(AtomicWeb.Endpoint, :show, member.user)
    |> JS.navigate()
  end
end
