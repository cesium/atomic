defmodule Atomic.Inventory.Product do
  @moduledoc """
  A product.
  """
  use Atomic.Schema
  alias Atomic.Inventory.Order
  alias Atomic.Uploaders

  @required_fields ~w(name description
                      price price_partnership stock max_per_user pre_order)a

  @optional_fields []

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :integer
    field :price_partnership, :integer
    field :stock, :integer
    field :max_per_user, :integer
    field :image, Uploaders.Image.Type
    field :pre_order, :boolean, default: false
    many_to_many :order, Order, join_through: Atomic.Inventory.OrdersProducts

    embeds_one :sizes, Sizes, on_replace: :delete do
      field :xs_size, :integer
      field :s_size, :integer
      field :m_size, :integer
      field :l_size, :integer
      field :xl_size, :integer
      field :xxl_size, :integer
    end

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, [:image])
    |> cast_embed(:sizes, required: true, with: &sizes_changeset/2)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def sizes_changeset(sizes, attrs) do
    sizes
    |> cast(attrs, [:xs_size, :s_size, :m_size, :l_size, :xl_size, :xxl_size])
    |> validate_required([:xs_size, :s_size, :m_size, :l_size, :xl_size, :xxl_size])
  end

  def image_changeset(product, attrs) do
    product
    |> cast_attachments(attrs, [:image])
  end
end
