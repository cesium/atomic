defmodule Atomic.Organizations.BoardDepartments do
  @moduledoc false
  use Atomic.Schema

  alias Atomic.Organizations.Board
  alias Atomic.Organizations.UserOrganization

  @required_fields ~w(name board_id priority)a

  schema "board_departments" do
    field :name, :string
    field :priority, :integer

    belongs_to :board, Board
    has_many :user_organization, UserOrganization

    timestamps()
  end

  def changeset(board_departments, attrs) do
    board_departments
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
