defmodule AtomicWeb.OrganizationLive.Components.MembershipBanner do
  @moduledoc """
  Organization membership banner component. Displays information about the organization's membership benefits and price.
  """
  use AtomicWeb, :component

  alias Atomic.Organizations.Organization

  attr :organization, Organization,
    required: true,
    doc: "the organization which membership banner to display"

  def membership_banner(assigns) do
    ~H"""
    <div class="mx-auto rounded-3xl ring-1 ring-gray-200 lg:mx-0 lg:flex lg:max-w-none">
      <div class="p-8 sm:p-10">
        <h3 class="text-2xl font-bold tracking-tight text-gray-900"><%= gettext("Lifetime membership") %></h3>
        <div class="mt-10 flex items-center gap-x-4">
          <h4 class="flex-none text-sm font-semibold leading-6 text-orange-600"><%= gettext("What’s included") %></h4>
          <div class="h-px flex-auto bg-gray-100"></div>
        </div>

        <ul role="list" class="mt-8 grid grid-cols-1 gap-4 text-sm leading-6 text-gray-600 sm:grid-cols-2 sm:gap-6">
          <li class="flex gap-x-3">
            <.icon name="hero-check" class="h-6 w-5 flex-none text-orange-600" />
            <p>Access to our room facilities</p>
          </li>
          <li class="flex gap-x-3">
            <.icon name="hero-check" class="h-6 w-5 flex-none text-orange-600" />
            <p>Free access to all activities</p>
          </li>
          <li class="flex gap-x-3">
            <.icon name="hero-check" class="h-6 w-5 flex-none text-orange-600" />
            <p>Official member t-shirt</p>
          </li>
        </ul>
      </div>

      <div class="-mt-2 p-2 lg:mt-0 lg:w-full lg:max-w-md lg:flex-shrink-0">
        <div class="ring-gray-900/5 rounded-2xl bg-gray-50 py-10 text-center ring-1 ring-inset lg:flex lg:flex-col lg:justify-center lg:py-16">
          <div class="mx-auto flex max-w-xs flex-col items-center px-8">
            <p class="text-base font-semibold text-gray-600"><%= gettext("Pay once, be a member forever") %></p>
            <p class="mt-6 flex items-baseline justify-center gap-x-2">
              <span class="text-5xl font-bold tracking-tight text-gray-900">10€</span>
              <span class="text-sm font-semibold leading-6 tracking-wide text-gray-600">EUR</span>
            </p>
            <.button icon="hero-banknotes" class="mt-10 text-sm"><%= gettext("Request your membership") %></.button>
            <p class="mt-6 text-xs leading-5 text-gray-600"><%= gettext("Payments should be made within our location.") %> <%= @organization.location %></p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
