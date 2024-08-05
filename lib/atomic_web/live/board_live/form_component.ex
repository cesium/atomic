defmodule AtomicWeb.BoardLive.FormComponent do
  use AtomicWeb, :live_component

  import AtomicWeb.Components.Forms

  alias Atomic.Accounts
  alias Atomic.Board
  alias Atomic.Organizations
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
          <%= if @action_modal in [:delete_board, :delete_department] do %>
            <p class="mt-4 text-sm text-gray-500">
              <%= gettext("This action cannot be undone.") %>
            </p>
          <% end %>
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
    changeset =
      case assigns.action do
        :new_board ->
          Board.change_board(%Organizations.Board{})

        :edit_board ->
          Board.change_board(assigns.board)

        :new_department ->
          Board.change_board_department(%Organizations.BoardDepartments{})

        :edit_department ->
          Board.change_board_department(Board.get_board_department!(assigns.department_id))

        _ ->
          Board.change_board(assigns.board)
      end

    # changeset = Board.change_board(assigns.board)
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
    IO.inspect("called save")

    case socket.assigns.action do
      :new_board -> save_board(socket, :new, board_params)
      :edit_board -> save_board(socket, :edit, board_params)
      :new_department -> save_department(socket, :new, board_params)
      :edit_department -> save_department(socket, :edit, board_params)
    end
  end

  @impl true
  def handle_event("update_department", board_params, socket) do
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
  def handle_event(action, _, socket) when action in ["delete_board", "delete_department"] do
    IO.inspect(action)

    {:noreply,
     socket
     |> assign(:action_modal, String.to_atom(action))}
  end

  @impl true
  def handle_event("confirm", _, socket) do
    case socket.assigns.action_modal do
      # :confirm_request -> accept_collaborator_request(socket)
      # :deny_request -> deny_collaborator_request(socket)
      :delete_board -> save_board(socket, :delete, socket.assigns.board)
      :delete_department -> save_department(socket, :delete, socket.assigns.department_id)
    end
  end

  @impl true
  def handle_event("remove_user", %{"user-id" => user_id}, socket) do
    IO.inspect(user_id)

    IO.puts("Remove user")

    {:noreply, assign(socket, :users, Board.get_board_department_users(socket.assigns.department_id))}
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

  defp save_board(socket, :edit, %{"board" => board_params}) do
    # board_params = Map.put(board_params, "organization_id", socket.assigns.organization_id)
    board = Board.get_board!(socket.assigns.board.id)
    IO.inspect(board)
    IO.puts("Edit board")

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
         |> assign(
           :return_to,
           Routes.board_index_path(socket, :index, socket.assigns.organization_id)
         )
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_department(socket, :new, department_params) do
    # department_params =
    # Map.put(department_params, "board", socket.assigns.board)

    # board_params = Map.put(%Board{}, "board", board_map)
    department_params =
      Map.put(department_params["board_departments"], "board_id", socket.assigns.board.id)
      |> Map.put("priority", 1)

    IO.inspect(department_params)

    case Board.create_board_department(department_params) do
      {:ok, board_deparment} ->
        {:noreply,
         socket
         |> put_flash(:success, "Department created successfully")
         |> push_navigate(
           to:
             Routes.board_index_path(
               socket,
               :show,
               socket.assigns.organization_id,
               socket.assigns.board.id
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_department(socket, :edit, department_params) do
    # department_params =
    # Map.put(department_params["board_departments"], "board_id", socket.assigns.board.id)
    department_params = department_params["board_departments"]
    department = Board.get_board_department!(socket.assigns.department_id)
    # board_params = Map.put(%Board{}, "board", board_map)

    IO.inspect(department_params)

    case Board.update_board_department(department, department_params) do
      {:ok, board_department} ->
        {:noreply,
         socket
         |> put_flash(:success, "Department updated successfully")
         |> push_navigate(
           to:
             Routes.board_index_path(
               socket,
               :show,
               socket.assigns.organization_id,
               socket.assigns.board.id
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_department(socket, :delete, _department_params) do
    department = Board.get_board_department!(socket.assigns.department_id)
    IO.inspect("called delete department")

    case Board.delete_board_department(department) do
      {:ok, _board} ->
        {:noreply,
         socket
         |> put_flash(:success, "Department deleted successfully")
         |> assign(
           :return_to,
           Routes.board_index_path(
             socket,
             :show,
             socket.assigns.organization_id,
             socket.assigns.board.id
           )
         )
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
          <.button size={:md} color={:danger} icon={:trash} type="button" phx-click="delete_board" phx-target={@myself}>Delete board</.button>
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

    <.form :let={f} id="department-form" for={@changeset} phx-target={@myself} phx-submit="save">
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
          <%= text_input(f, :users, class: "rounded-lg border-zinc-200 focus:ring-primary-500 focus:border-primary-500", phx_click: show_dropdown(), phx_change: "update_department", phx_target: @myself, autocomplete: "off", id: "department-users-input") %>
          <div class="h-48 overflow-clip rounded-lg border border-zinc-200">
            <%= if Board.get_board_department_users(@department_id) == {} do %>
              <p class="text-zinc-600">Empty...</p>
            <% end %>
            <div class="h-48 overflow-y-auto">
              <ul class="flex flex-col items-center justify-center divide-y divide-zinc-200">
                <%= for user_organization <- Board.get_board_department_users(@department_id) do %>
                  <li class="w-full">
                    <div class="flex items-center justify-between p-2">
                      <p><%= user_organization.user.name %></p>
                      <.button color={:light} type="button" phx-target={@myself} phx-click="remove_user" phx-value-user-id={user_organization.user.id} class="max-h-8">
                        <span class="h-4 w-4 select-none">
                          <.icon name={:trash} />
                        </span>
                      </.button>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>
          </div>

          <%!-- <div id="department-users-dropdown" class="absolute top-full z-10 hidden w-full origin-top overflow-hidden rounded-b-lg bg-white shadow-lg ring-1 ring-black ring-opacity-5" phx-click-away={hide_dropdown()}>
              <%!-- <div class="max-h-44 overflow-y-scroll">
                <%= for user <- @users do %>
                  <a href="#" class="flex items-center gap-x-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900" role="menuitem">
                    <%= user.name %>
                  </a>
                <% end %>
              </div>
            </div> --%>
        </div>
        <%= error_tag(f, :users) %>
      </div>

      <div class="mt-4 flex w-full justify-end space-x-4">
        <%= if @action in [:edit_department] do %>
          <.button size={:md} color={:danger} icon={:trash} type="button" phx-click="delete_department" phx-target={@myself} full_width>Delete department</.button>
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
        gettext("Are you sure you want to remove this board?")

      :delete_department ->
        gettext("Are you sure you want to remove this department?")

      _ ->
        gettext("Are you sure you want to perform this action?")
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
