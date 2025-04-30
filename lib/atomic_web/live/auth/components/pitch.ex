defmodule AtomicWeb.Auth.Components.Pitch do
  @moduledoc false
  use AtomicWeb, :component

  def pitch(assigns) do
    ~H"""
    <div class="bg-white py-24 sm:py-32">
      <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8">
        <h2 class="text-base/7 text-primary-600 font-semibold">{gettext("Connect. Organize. Engage.")}</h2>
        <p class="text-pretty mt-2 text-4xl font-semibold tracking-tight text-gray-950 sm:text-5xl">{gettext("Your Campus, Connected")}</p>
        <div class="mt-10 grid grid-cols-1 gap-4 sm:mt-16 lg:grid-cols-6">
          <div class="relative lg:col-span-3">
            <div class="absolute inset-px rounded-lg bg-white max-lg:rounded-t-[2rem] lg:rounded-tl-[2rem]"></div>
            <div class="relative flex h-full flex-col overflow-hidden rounded-[calc(theme(borderRadius.lg)+1px)] max-lg:rounded-t-[calc(2rem+1px)] lg:rounded-tl-[calc(2rem+1px)]">
              <img class="h-[22rem] object-cover object-top" src={~p"/images/pitch/0.png"} alt="" />
              <div class="p-10 pt-4">
                <h3 class="text-sm/4 text-primary-600 font-semibold">{gettext("Stay in the Loop")}</h3>
                <p class="mt-2 text-lg font-medium tracking-tight text-gray-950">{gettext("Everything, all in the same place")}</p>
                <p class="text-sm/6 mt-2 max-w-lg text-gray-600">{gettext("Get the latest updates from your favorite student associations in a single, organized feed—no more missed events or scattered information.")}</p>
              </div>
            </div>
            <div class="ring-black/5 pointer-events-none absolute inset-px rounded-lg shadow ring-1 max-lg:rounded-t-[2rem] lg:rounded-tl-[2rem]"></div>
          </div>
          <div class="relative lg:col-span-3">
            <div class="absolute inset-px rounded-lg bg-white lg:rounded-tr-[2rem]"></div>
            <div class="relative flex h-full flex-col overflow-hidden rounded-[calc(theme(borderRadius.lg)+1px)] lg:rounded-tr-[calc(2rem+1px)]">
              <img class="h-[22rem] object-cover object-left lg:object-right" src={~p"/images/pitch/1.png"} alt="" />
              <div class="p-10 pt-4">
                <h3 class="text-sm/4 text-primary-600 font-semibold">{gettext("Activities made easy")}</h3>
                <p class="mt-2 text-lg font-medium tracking-tight text-gray-950">{gettext("Plan, promote, and track attendance")}</p>
                <p class="text-sm/6 mt-2 max-w-lg text-gray-600">
                  {gettext("Simplify activity organization with participant limits, location tracking, and digital certificates—all in one place.")}
                </p>
              </div>
            </div>
            <div class="ring-black/5 pointer-events-none absolute inset-px rounded-lg shadow ring-1 lg:rounded-tr-[2rem]"></div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
