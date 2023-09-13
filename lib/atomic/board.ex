defmodule Atomic.Board do
  @moduledoc """
  The Boards context.
  """
  use Atomic.Context

  alias Atomic.Organizations.Board
  alias Atomic.Organizations.BoardDepartments
  alias Atomic.Organizations.UserOrganization

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards do
    Repo.all(Board)
  end

  @doc """
  Returns the list of boards belonging to an organization.

  ## Examples

      iex> list_boards_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%Board{}, ...]

  """
  def list_boards_by_organization_id(id) do
    Repo.all(from d in Board, where: d.organization_id == ^id)
  end

  @doc """
  Returns the list of boards in a list of given ids.

  ## Examples

      iex> get_boards([99d7c9e5-4212-4f59-a097-28aaa33c2621, 99d7c9e5-4212-4f59-a097-28aaa33c2621])
      [%Board{}, ...]

      iex> get_boards(nil)
      []
  """
  def get_boards(nil), do: []

  def get_boards(ids) do
    Repo.all(from d in Board, where: d.id in ^ids)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id, opts \\ []) do
    Board
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  def get_organization_board_by_year(year, organization_id) do
    Repo.get_by(Board, year: year, organization_id: organization_id)
  end

  @doc """
  Returns the list of board_departments.

  ## Examples

      iex> list_board_departments()
      [%BoardDepartments{}, ...]

  """
  def list_board_departments do
    Repo.all(BoardDepartments)
  end

  @doc """
  Returns the list of board_departments belonging to an organization.

  ## Examples

      iex> list_board_departments_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%BoardDepartments{}, ...]

  """
  def list_board_departments_by_organization_id(id) do
    Repo.all(from d in BoardDepartments, where: d.organization_id == ^id)
  end

  @doc """
  Returns the list of board_departments in a list of given ids.

  ## Examples

      iex> get_board_departments([99d7c9e5-4212-4f59-a097-28aaa33c2621, 99d7c9e5-4212-4f59-a097-28aaa33c2621])
      [%BoardDepartments{}, ...]

      iex> get_board_departments(nil)
      []
  """
  def get_board_departments(nil), do: []

  def get_board_departments(ids) do
    Repo.all(from d in BoardDepartments, where: d.id in ^ids)
  end

  def get_board_departments_by_board_id(board_id, _preloads \\ []) do
    Repo.all(from d in BoardDepartments, where: d.board_id == ^board_id)
    |> Enum.sort_by(& &1.priority)
  end

  def get_board_department_users(board_departments_id, opts \\ []) do
    UserOrganization
    |> where([u], u.board_departments_id == ^board_departments_id)
    |> order_by([u], u.priority)
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Gets a single board_departments.

  Raises `Ecto.NoResultsError` if the BoardDepartments does not exist.

  ## Examples

      iex> get_board_department!(123)
      %BoardDepartments{}

      iex> get_board_department!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_department!(id, opts \\ []) do
    BoardDepartments
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a board_departments.

  ## Examples

      iex> create_board_department(%{field: value})
      {:ok, %BoardDepartments{}}

      iex> create_board_department(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board_department(attrs \\ %{}) do
    %BoardDepartments{}
    |> BoardDepartments.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board_departments.

  ## Examples

      iex> update_board_department(board_departments, %{field: new_value})
      {:ok, %BoardDepartments{}}

      iex> update_board_department(board_departments, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board_department(%BoardDepartments{} = board_departments, attrs) do
    board_departments
    |> BoardDepartments.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board_departments.

  ## Examples

      iex> delete_board_department(board_departments)
      {:ok, %BoardDepartments{}}

      iex> delete_board_department(board_departments)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board_department(%BoardDepartments{} = board_departments) do
    Repo.delete(board_departments)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board_departments changes.

  ## Examples

      iex> change_board_department(board_departments)
      %Ecto.Changeset{data: %BoardDepartments{}}

  """
  def change_board_department(%BoardDepartments{} = board_departments, attrs \\ %{}) do
    BoardDepartments.changeset(board_departments, attrs)
  end
end
