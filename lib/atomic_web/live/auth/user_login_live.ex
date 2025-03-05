defmodule AtomicWeb.Auth.UserLoginLive do
  use AtomicWeb, :auth_view

  import AtomicWeb.Components.Forms

  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen">
      <div class="flex flex-1 flex-col justify-center px-4 py-12 sm:px-6 lg:flex-none lg:px-20 xl:px-24">
        <div class="mx-auto w-full max-w-sm lg:w-96">
          <div>
            <div class="flex h-16 shrink-0 select-none items-center gap-x-4 pt-4">
              <img src={~p"/images/atomic.svg"} class="h-14 w-auto" />
              <p class="text-2xl font-semibold text-zinc-400">Atomic</p>
            </div>
            <h2 class="text-2xl/9 mt-8 font-semibold tracking-tight text-gray-900"><%= gettext("Sign in to your account") %></h2>
            <p class="text-sm/6 mt-2 text-gray-500">
              <%= gettext("Not a member?") %>
              <.link patch={~p"/users/register"} class="text-primary-600 font-semibold hover:text-primary-700"><%= gettext("Sign up here") %></.link>
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
                    <%= gettext("Forgot your password?") %>
                  </.link>
                </div>

                <div>
                  <.button class="w-full" size={:md}>
                    <%= gettext("Log in") %>
                  </.button>
                </div>
              </.form>
            </div>

            <div class="mt-10">
              <div class="relative">
                <div class="absolute inset-0 flex items-center" aria-hidden="true">
                  <div class="w-full border-t border-gray-200"></div>
                </div>
                <div class="text-sm/6 relative flex justify-center font-medium">
                  <span class="bg-white px-6 text-gray-900"><%= gettext("Or continue with") %></span>
                </div>
              </div>

              <div class="mt-6 select-none">
                <.link navigate="/auth/google" class="flex w-full items-center justify-center gap-3 rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus-visible:ring-transparent">
                  <svg class="h-5 w-5" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M12.0003 4.75C13.7703 4.75 15.3553 5.36002 16.6053 6.54998L20.0303 3.125C17.9502 1.19 15.2353 0 12.0003 0C7.31028 0 3.25527 2.69 1.28027 6.60998L5.27028 9.70498C6.21525 6.86002 8.87028 4.75 12.0003 4.75Z" fill="#EA4335" />
                    <path d="M23.49 12.275C23.49 11.49 23.415 10.73 23.3 10H12V14.51H18.47C18.18 15.99 17.34 17.25 16.08 18.1L19.945 21.1C22.2 19.01 23.49 15.92 23.49 12.275Z" fill="#4285F4" />
                    <path d="M5.26498 14.2949C5.02498 13.5699 4.88501 12.7999 4.88501 11.9999C4.88501 11.1999 5.01998 10.4299 5.26498 9.7049L1.275 6.60986C0.46 8.22986 0 10.0599 0 11.9999C0 13.9399 0.46 15.7699 1.28 17.3899L5.26498 14.2949Z" fill="#FBBC05" />
                    <path d="M12.0004 24.0001C15.2404 24.0001 17.9654 22.935 19.9454 21.095L16.0804 18.095C15.0054 18.82 13.6204 19.245 12.0004 19.245C8.8704 19.245 6.21537 17.135 5.2654 14.29L1.27539 17.385C3.25539 21.31 7.3104 24.0001 12.0004 24.0001Z" fill="#34A853" />
                  </svg>
                  <span class="text-sm/6 font-semibold">Google</span>
                </.link>
              </div>
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
