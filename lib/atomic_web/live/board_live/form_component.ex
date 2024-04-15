defmodule AtomicWeb.BoardLive.FormComponent do
  use AtomicWeb, :live_component

  import AtomicWeb.Components.Forms

  alias Atomic.Accounts
  alias Atomic.Board
  alias Phoenix.LiveView.JS

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= forms(assigns) %>
      <!-- Action Confirm Modal -->
      <.modal :if={@action_modal} id="action-confirm-modal" show on_cancel={JS.push("clear-action", target: @myself)}>
        <div class="flex flex-col">
          <h1 class="flex-1 select-none truncate text-lg font-semibold text-gray-900">
            <%= display_action_goal_confirm_title(@action_modal) %>
          </h1>
          <p class="mt-4">
            <%= display_action_goal_confirm_description(@action_modal, @board) %>
          </p>
          <div class="mt-8 flex flex-row">
            <.button phx-click="clear-action" class="mr-2" phx-target={@myself} size={:lg} icon={:x_circle} color={:white} full_width>Cancel</.button>
            <.button
              phx-click="confirm"
              class="ml-2"
              phx-target={@myself}
              size={:lg}
              icon={:check_circle}
              color={
                if @action_modal in [:delete_board, :delete_department] do
                  :danger
                else
                  :success
                end
              }
              full_width
            >
              Confirm
            </.button>
          </div>
        </div>
      </.modal>
    </div>
    """
  end

  @impl true
  def update(%{organization_id: _org} = assigns, socket) do
    changeset = Board.change_board(assigns.board)
    # users = Enum.map(Accounts.list_users(), fn u -> [key: u.email, value: u.id] end)
    hide_dropdown()
    # users = Accounts.list_users()
    users = %{}

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:action_modal, nil)
     |> assign(users: users)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"board" => board_params}, socket) do
    changeset =
      socket.assigns.user_organization
      # |> Organizations.change_user_organization(user_organization_params)
      |> Board.change_board(board_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("clear-action", _, socket) do
    {:noreply,
     socket
     |> assign(:action_modal, nil)}
  end

  @impl true
  def handle_event("save", board_params, socket) do
    # save_user_organization(socket, socket.assigns.action, user_organization_params)
    if socket.assigns.action == :new_board do
      save_board(socket, :new, board_params)
    else
      save_board(socket, :edit, board_params)
    end
  end

  @impl true
  def handle_event("update", board_params, socket) do
    users =
      Enum.filter(Accounts.list_users(), fn u ->
        String.starts_with?(String.downcase(u.name), board_params["board"]["users"])
      end)

    # show_dropdown()

    {:noreply,
     socket
     |> assign(:users, users)}
  end

  @impl true
  def handle_event("delete", _, socket) do
    {:noreply,
     socket
     |> assign(:action_modal, :delete_board)}
  end

  @impl true
  def handle_event("confirm", _, socket) do
    case socket.assigns.action_modal do
      # :confirm_request -> accept_collaborator_request(socket)
      # :deny_request -> deny_collaborator_request(socket)
      :delete_board -> save_board(socket, :delete, socket.assigns.board)
    end
  end

  defp save_board(socket, :new, board_params) do
    board_params =
      Map.put(board_params["board"], "organization_id", socket.assigns.organization_id)

    # board_params = Map.put(%Board{}, "board", board_map)

    IO.inspect(board_params)

    case Board.create_board(board_params) do
      {:ok, board} ->
        {:noreply,
         socket
         |> put_flash(:success, "Board created successfully")
         |> push_navigate(
           to: Routes.board_index_path(socket, :show, socket.assigns.organization_id, board.id)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_board(socket, :edit, board_params) do
    board_params = Map.put(board_params, "organization_id", socket.assigns.organization_id)
    board = Board.get_board!(socket.assigns.board.id)

    case Board.update_board(board, board_params) do
      {:ok, _board} ->
        {:noreply,
         socket
         |> put_flash(:success, "Board edited successfully")
         |> push_patch(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_board(socket, :delete, _board_params) do
    board = Board.get_board!(socket.assigns.board.id)
    IO.inspect(socket.assigns.return_to)

    case Board.delete_board(board) do
      {:ok, _board} ->
        {:noreply,
         socket
         |> put_flash(:success, "Board deleted successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp forms(%{action: action} = assigns) when action in [:new_board, :edit_board] do
    ~H"""
    <h1 class="flex-1 select-none truncate text-lg font-semibold text-gray-900"><%= @title %></h1>

    <.form :let={f} for={@changeset} id="board-form" phx-target={@myself} phx-submit="save">
      <%!-- <%= label(f, :user_id) %> --%>
      <%!-- <%= select(f, :user_id, @users) %> --%>
      <%!-- <%= label(f, :title) %> --%>
      <%!-- <%= text_input(f, :title) %> --%>
      <div class="flex flex-col gap-y-1">
        <.field field={f[:name]} id="name" label="Name" type="text" placeholder="Board name" />
      </div>

      <div class="mt-4 flex w-full justify-end space-x-4">
        <%= if @action in [:edit_board] do %>
          <.button size={:md} color={:danger} icon={:trash} type="button" phx-click="delete" phx-target={@myself}>Delete board</.button>
        <% end %>
        <.button size={:md} color={:white} icon={:check}>Save Changes</.button>
      </div>
    </.form>
    """
  end

  defp forms(%{action: action} = assigns) when action in [:new_department, :edit_department] do
    ~H"""
    <h1 class="flex-1 select-none truncate text-lg font-semibold text-gray-900">
      <%= if action == :new_department do %>
        New Department
      <% else %>
        Edit Department
      <% end %>
    </h1>

    <.form :let={f} id="board-form" for={@changeset} phx-target={@myself} phx-submit="save">
      <%!-- <%= label(f, :user_id) %> --%>
      <%!-- <%= select(f, :user_id, @users) %> --%>
      <%!-- <%= label(f, :title) %> --%>
      <%!-- <%= text_input(f, :title) %> --%>
      <div class="flex flex-col gap-y-1">
        <div>
          <%= label(f, :name, class: "text-sm font-semibold") %>
          <p class="text-xs text-gray-500">The name of the department</p>
        </div>
        <%= text_input(f, :name, class: "rounded-lg border-zinc-200 focus:ring-primary-500 focus:border-primary-500") %>
        <%= error_tag(f, :name) %>
      </div>

      <div class="flex flex-col gap-y-1">
        <div>
          <%= label(f, :users, class: "text-sm font-semibold") %>
          <p class="text-xs text-gray-500">The name of the department</p>
        </div>
        <%!-- <%= select(f, :user_id, @users, class: "rounded-lg border-zinc-200 focus:ring-primary-500 focus:border-primary-500") %> --%>
        <%!-- <.live_component module={MultiSelect} id="users" items={@users} selected_items={[]} target={@myself} /> --%>
        <div class="flex flex-col">
          <%= text_input(f, :users, class: "rounded-lg border-zinc-200 focus:ring-primary-500 focus:border-primary-500", phx_click: show_dropdown(), phx_change: "update", phx_target: @myself, autocomplete: "off", id: "department-users-input") %>
          <div class="relative">
            <div id="department-users-dropdown" class="absolute top-full z-10 hidden w-full origin-top overflow-hidden rounded-b-lg bg-white shadow-lg ring-1 ring-black ring-opacity-5" phx-click-away={hide_dropdown()}>
              <div class="max-h-44 overflow-y-scroll">
                <%= for user <- @users do %>
                  <a href="#" class="flex items-center gap-x-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900" role="menuitem">
                    <%= user.name %>
                  </a>
                <% end %>
              </div>
            </div>
          </div>
        </div>
        <%= error_tag(f, :users) %>
      </div>

      <div class="mt-4 flex w-full justify-end space-x-4">
        <%= if @action in [:edit_board, :edit_department] do %>
          <.button size={:md} color={:danger} icon={:trash} phx-click="delete" phx-target={@myself} full_width>Delete department</.button>
        <% end %>
        <.button size={:md} color={:white} icon={:check} full_width>Save Changes</.button>
      </div>
    </.form>
    """
  end

  defp display_action_goal_confirm_title(action) do
    case action do
      :confirm_request ->
        gettext("Are you sure you want to accept this request?")

      :deny_request ->
        gettext("Are you sure you want to deny this request?")

      :delete_board ->
        gettext("Are you sure you want to remove this person from the department?")
    end
  end

  defp display_action_goal_confirm_description(action, board) do
    case action do
      :confirm_request ->
        gettext("If you change your mind you can always remove this person later.")

      :deny_request ->
        gettext("If you deny this request, this person will not get access to the department.")

      :delete_board ->
        gettext(
          "If you remove this person, they will no longer have access to %{department_name}.",
          department_name: board.name
        )
    end
  end

  defp hide_dropdown(js \\ %JS{}) do
    js
    |> JS.remove_class("rounded-t-lg", to: "#department-users-input")
    |> JS.add_class("rounded-lg", to: "#department-users-input")
    |> JS.hide(
      transition: {"ease-in duration-150", "scale-y-100", "scale-y-0"},
      to: "#department-users-dropdown"
    )
  end

  defp show_dropdown(js \\ %JS{}) do
    js
    |> JS.remove_class("rounded-lg", to: "#department-users-input")
    |> JS.add_class("rounded-t-lg", to: "#department-users-input")
    |> JS.show(
      transition: {"ease-out duration-150", "scale-y-0", "scale-y-100"},
      to: "#department-users-dropdown"
    )
  end
end
