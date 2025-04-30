defmodule Atomic.Certificate do
  use Atomic.Schema

  alias Atomic.Organization

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "certificates" do
    field :title, :integer
    field :organization, :boolean, default: false
    field :background, :boolean, default: false
    field :content, :string
    field :background_color, :string
    field :title_color, :string
    field :content_color, :string
    field :organization_color, :string
    belongs_to :organization_id, Organization

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, [:background, :title, :content, :organization, :background_color, :title_color, :content_color, :organization_color])
    |> validate_required([:background, :title, :content, :organization, :background_color, :title_color, :content_color, :organization_color])
  end
end
