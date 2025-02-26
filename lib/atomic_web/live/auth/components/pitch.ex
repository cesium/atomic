defmodule AtomicWeb.Auth.Components.Pitch do
  use AtomicWeb, :component

  def pitch(assigns) do
    ~H"""
    <div class="bg-white py-24 sm:py-32">
      <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8">
        <h2 class="text-base/7 font-semibold text-primary-600">Deploy faster</h2>
        <p class="mt-2 max-w-lg text-pretty text-4xl font-semibold tracking-tight text-gray-950 sm:text-5xl">Everything you need to deploy your app</p>
        <div class="mt-10 grid grid-cols-1 gap-4 sm:mt-16 lg:grid-cols-6">
          <div class="relative lg:col-span-3">
            <div class="absolute inset-px rounded-lg bg-white max-lg:rounded-t-[2rem] lg:rounded-tl-[2rem]"></div>
            <div class="relative flex h-full flex-col overflow-hidden rounded-[calc(theme(borderRadius.lg)+1px)] max-lg:rounded-t-[calc(2rem+1px)] lg:rounded-tl-[calc(2rem+1px)]">
              <img class="h-80 object-cover object-left" src="https://tailwindui.com/plus-assets/img/component-images/bento-01-performance.png" alt="">
              <div class="p-10 pt-4">
                <h3 class="text-sm/4 font-semibold text-primary-600">Performance</h3>
                <p class="mt-2 text-lg font-medium tracking-tight text-gray-950">Lightning-fast builds</p>
                <p class="mt-2 max-w-lg text-sm/6 text-gray-600">Lorem ipsum dolor sit amet, consectetur adipiscing elit. In gravida justo et nulla efficitur, maximus egestas sem pellentesque.</p>
              </div>
            </div>
            <div class="pointer-events-none absolute inset-px rounded-lg shadow ring-1 ring-black/5 max-lg:rounded-t-[2rem] lg:rounded-tl-[2rem]"></div>
          </div>
          <div class="relative lg:col-span-3">
            <div class="absolute inset-px rounded-lg bg-white lg:rounded-tr-[2rem]"></div>
            <div class="relative flex h-full flex-col overflow-hidden rounded-[calc(theme(borderRadius.lg)+1px)] lg:rounded-tr-[calc(2rem+1px)]">
              <img class="h-80 object-cover object-left lg:object-right" src="https://tailwindui.com/plus-assets/img/component-images/bento-01-releases.png" alt="">
              <div class="p-10 pt-4">
                <h3 class="text-sm/4 font-semibold text-primary-600">Releases</h3>
                <p class="mt-2 text-lg font-medium tracking-tight text-gray-950">Push to deploy</p>
                <p class="mt-2 max-w-lg text-sm/6 text-gray-600">Curabitur auctor, ex quis auctor venenatis, eros arcu rhoncus massa, laoreet dapibus ex elit vitae odio.</p>
              </div>
            </div>
            <div class="pointer-events-none absolute inset-px rounded-lg shadow ring-1 ring-black/5 lg:rounded-tr-[2rem]"></div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
