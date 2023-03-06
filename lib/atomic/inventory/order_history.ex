defmodule Atomic.Inventory.OrderHistory do
  use Atomic.Schema

  alias Atomic.Accounts.User
  alias Atomic.Inventory.Order
  @required_fields ~w(admin_id status order_id)a
  @status ~w(draft ordered ready paid canceled delivered)a

  schema "orders_history" do
    belongs_to :admin, User
    field :status, Ecto.Enum, values: @status, default: :draft
    belongs_to :order, Order
    timestamps()
  end

  @doc false
  def changeset(order_history, attrs) do
    order_history
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
