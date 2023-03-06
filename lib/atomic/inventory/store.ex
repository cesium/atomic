defmodule Atomic.Inventory.Store do
  use Atomic.Schema

  alias Atomic.Organizations.Organization
  alias Atomic.Inventory.Product
  @required_fields ~w(organization_id)a

  schema "stores" do
    belongs_to :organization, Organization

    has_many :products, Product,
      on_replace: :delete_if_exists,
      on_delete: :delete_all,
      foreign_key: :store_id,
      preload_order: [asc: :name]

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
