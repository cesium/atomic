defmodule Atomic.Certificate do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Organizations.Organization

  @required_fields ~w(background title content background_color title_color content_color organization_color organization_id)a

  schema "certificates" do
    field :title, :integer
    field :background, :boolean, default: false
    field :content, :string
    field :background_color, :string
    field :title_color, :string
    field :content_color, :string
    field :organization_color, :string
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(certificate, attrs) do
    certificate
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
