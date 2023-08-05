defmodule Atomic.Departments do
  @moduledoc """
  The Departments context.
  """
  use Atomic.Context

  import Ecto.Query, warn: false

  alias Atomic.Departments.Department

  @doc """
  Returns the list of departments.

  ## Examples

      iex> list_departments()
      [%Department{}, ...]

  """
  def list_departments do
    Repo.all(Department)
  end

  @doc """
  Returns the list of departments belonging to an organization.

  ## Examples

      iex> list_departments_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%Department{}, ...]

  """
  def list_departments_by_organization_id(id) do
    Repo.all(from d in Department, where: d.organization_id == ^id)
  end

  @doc """
  Returns the list of departments in a list of given ids.

  ## Examples

      iex> get_departments([99d7c9e5-4212-4f59-a097-28aaa33c2621, 99d7c9e5-4212-4f59-a097-28aaa33c2621])
      [%Department{}, ...]

      iex> get_departments(nil)
      []
  """
  def get_departments(nil), do: []

  def get_departments(ids) do
    Repo.all(from d in Department, where: d.id in ^ids)
  end

  @doc """
  Gets a single department.

  Raises `Ecto.NoResultsError` if the Department does not exist.

  ## Examples

      iex> get_department!(123)
      %Department{}

      iex> get_department!(456)
      ** (Ecto.NoResultsError)

  """
  def get_department!(id, opts \\ []) do
    Department
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a department.

  ## Examples

      iex> create_department(%{field: value})
      {:ok, %Department{}}

      iex> create_department(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_department(attrs \\ %{}) do
    %Department{}
    |> Department.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a department.

  ## Examples

      iex> update_department(department, %{field: new_value})
      {:ok, %Department{}}

      iex> update_department(department, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_department(%Department{} = department, attrs) do
    department
    |> Department.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a department.

  ## Examples

      iex> delete_department(department)
      {:ok, %Department{}}

      iex> delete_department(department)
      {:error, %Ecto.Changeset{}}

  """
  def delete_department(%Department{} = department) do
    Repo.delete(department)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking department changes.

  ## Examples

      iex> change_department(department)
      %Ecto.Changeset{data: %Department{}}

  """
  def change_department(%Department{} = department, attrs \\ %{}) do
    Department.changeset(department, attrs)
  end
end
