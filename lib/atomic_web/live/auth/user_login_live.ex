defmodule AtomicWeb.Auth.UserLoginLive do
  use AtomicWeb, :auth_view

  import AtomicWeb.Components.Forms

  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen">
      <div aria-live="assertive" class="pointer-events-none fixed inset-0 z-50 flex flex-col items-end gap-y-2 px-4 py-4 sm:items-start sm:px-6">
        <%= for {key, message} <- @flash do %>
          <.live_component id={key} module={AtomicWeb.Components.Notification} type={key} message={message} flash={@flash} />
        <% end %>
      </div>
      <div class="flex flex-1 flex-col justify-center px-4 py-12 sm:px-6 lg:flex-none lg:px-20 xl:px-24">
        <div class="mx-auto w-full max-w-sm lg:w-96">
          <div>
            <div class="flex h-16 shrink-0 select-none items-center gap-x-4 pt-4">
              <img src={~p"/images/atomic.svg"} class="h-14 w-auto" />
              <p class="text-2xl font-semibold text-zinc-400">Atomic</p>
            </div>
            <h2 class="text-2xl/9 mt-8 font-semibold tracking-tight text-gray-900">{gettext("Sign in to your account")}</h2>
            <p class="text-sm/6 mt-2 text-gray-500">
              {gettext("Not a member?")}
              <.link patch={~p"/users/register"} class="text-primary-600 font-semibold hover:text-primary-700">{gettext("Sign up here")}</.link>
            </p>
          </div>

          <div class="mt-10">
            <div>
              <.form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
                <.field field={@form[:email]} type="email" label="Email" required />
                <.field field={@form[:password]} type="password" label="Password" required />
                <div class="flex justify-between">
                  <div class="flex gap-3">
                    <.field field={@form[:remember_me]} type="checkbox" label="Remember me" />
                  </div>
                  <.link patch={~p"/users/reset_password"} class="text-primary-600 text-sm font-semibold hover:text-primary-700">
                    {gettext("Forgot your password?")}
                  </.link>
                </div>

                <div>
                  <.button class="w-full" size={:md}>
                    {gettext("Log in")}
                  </.button>
                </div>
              </.form>
            </div>
          </div>
        </div>
      </div>
      <div class="relative hidden w-0 flex-1 lg:block">
        <img class="size-full absolute inset-0 object-cover" src={~p"/images/backgrounds/0.png"} alt="" />
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
