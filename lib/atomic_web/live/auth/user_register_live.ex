defmodule AtomicWeb.Auth.UserRegisterLive do
  use AtomicWeb, :auth_view

  alias Atomic.Accounts
  alias Atomic.Accounts.User

  import AtomicWeb.Components.Forms

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen">
      <div aria-live="assertive" class="pointer-events-none fixed inset-0 z-50 flex flex-col items-end gap-y-2 px-4 py-4 sm:items-start sm:px-6">
        <%= for {key, message} <- @flash do %>
          <.live_component id={key} module={AtomicWeb.Components.Notification} type={key} message={message} flash={@flash} />
        <% end %>
      </div>
      <div class="flex flex-1 flex-col justify-center border px-4 py-12 sm:px-6 lg:flex-none lg:px-20 xl:px-24">
        <div class="mx-auto w-full max-w-sm lg:w-96">
          <div>
            <div class="flex h-16 shrink-0 select-none items-center gap-x-4 pt-4">
              <img src={~p"/images/logo_atomic_extended.svg"} class="pointer-events-none h-12 w-auto" />
            </div>
            <h2 class="text-2xl/9 mt-8 font-semibold tracking-tight text-gray-900">{gettext("Register for an account")}</h2>
            <p class="text-sm/6 mt-2 text-gray-500">
              {gettext("Already have an account?")}
              <.link patch={~p"/users/log_in"} class="text-primary-600 font-semibold hover:text-primary-700">{gettext("Log in")}</.link>
            </p>
          </div>

          <div class="mt-10">
            <div>
              <.form for={@form} id="register_form" action={~p"/users/register"} phx-update="ignore">
                <.field field={@form[:name]} type="text" label="Name" required />
                <.field field={@form[:email]} type="email" label="Email" required />
                <.field field={@form[:password]} type="password" label="Password" required />
                <.field field={@form[:confirm_password]} type="password" label="Confirm Password" required />
                <div class="flex justify-between">
                  <div class="flex gap-1">
                    <.field field={@form[:terms]} type="checkbox" label="" required />
                    <p class="text-sm">{gettext("I agree to the")}
                      <.link navigate={~p"/tos"} target="_blank" class="text-primary-600 font-semibold hover:text-primary-700">{gettext("terms of service")}</.link>
                      {gettext("and")}
                      <.link navigate={~p"/privacy"} target="_blank" class="text-primary-600 font-semibold hover:text-primary-700">{gettext("privacy policy.")}</.link></p>
                  </div>
                </div>
                <div>
                  <.button class="mt-4 w-full sm:mt-0" size={:md}>
                    {gettext("Sign up")}
                  </.button>
                </div>
              </.form>
            </div>
          </div>
        </div>
      </div>
      <div class="relative hidden w-0 flex-1 lg:block">
        <.pitch />
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
