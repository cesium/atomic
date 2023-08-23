defmodule Atomic.Organizations.Board do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Ecto.Year
  alias Atomic.Organizations.BoardDepartments
  alias Atomic.Organizations.Organization

  @required_fields ~w(year organization_id)a

  schema "boards" do
    field :year, Year
    has_many :board_departments, BoardDepartments

    belongs_to :organization, Organization

    timestamps()
  end

  def changeset(board, attrs) do
    board
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
