defmodule Atomic.Departments do
  @moduledoc """
  The Departments context.
  """
  use Atomic.Context

  alias Atomic.Activities.SessionDepartment
  alias Atomic.Organizations.Collaborator
  alias Atomic.Organizations.Department

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
  def list_departments_by_organization_id(id, opts \\ []) do
    Department
    |> where([d], d.organization_id == ^id)
    |> apply_filters(opts)  
    |> Repo.all()
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
  Returns the list of activity sessions that belong to a department.

  ## Examples

      iex> get_department_sessions(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%Session{}, ...]

  """
  def get_department_sessions(department_id) do
    Repo.all(from s in SessionDepartment, where: s.department_id == ^department_id)
    |> Repo.preload([:session, session: :activity])
    |> Enum.map(& &1.session)
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

  @doc """
  Returns the list of collaborators.

  ## Examples

      iex> list_collaborators()
      [%Collaborator{}, ...]

  """
  def list_collaborators do
    Repo.all(Collaborator)
  end

  @doc """
  Returns the list of collaborators belonging to an organization.

  ## Examples

      iex> list_collaborators_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%Collaborator{}, ...]

  """
  def list_collaborators_by_organization_id(id) do
    Repo.all(from p in Collaborator, where: p.organization_id == ^id)
  end

  @doc """
  Gets a single collaborator.

  Raises `Ecto.NoResultsError` if the Collaborator does not exist.

  ## Examples

      iex> get_collaborator!(123)
      %Collaborator{}

      iex> get_collaborator!(456)
      ** (Ecto.NoResultsError)

  """
  def get_collaborator!(id), do: Repo.get!(Collaborator, id)

  @doc """
  Gets a single collaborator.

  Returns `nil` if the Collaborator does not exist.

  ## Examples

      iex> get_collaborator(123)
      %Collaborator{}

      iex> get_collaborator(456)
      nil

  """
  def get_collaborator(id), do: Repo.get(Collaborator, id)

  @doc """
  Gets a single collaborator from a department.

  Returns `nil` if the Collaborator does not exist.

  ## Examples

      iex> get_department_collaborator(123, 456)
      %Collaborator{}

      iex> get_department_collaborator(456, 123)
      nil
  """
  def get_department_collaborator(department_id, user_id) do
    Repo.get_by(Collaborator, department_id: department_id, user_id: user_id)
  end

  @doc """
  Creates a collaborator.

  ## Examples

      iex> create_collaborator(%{field: value})
      {:ok, %Collaborator{}}

      iex> create_collaborator(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_collaborator(attrs \\ %{}, _after_save \\ &{:ok, &1}) do
    %Collaborator{}
    |> Collaborator.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collaborator.

  ## Examples

      iex> update_collaborator(collaborator, %{field: new_value})
      {:ok, %Collaborator{}}

      iex> update_collaborator(collaborator, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_collaborator(%Collaborator{} = collaborator, attrs, _after_save \\ &{:ok, &1}) do
    collaborator
    |> Collaborator.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a collaborator.

  ## Examples

      iex> delete_collaborator(collaborator)
      {:ok, %Collaborator{}}

      iex> delete_collaborator(collaborator)
      {:error, %Ecto.Changeset{}}

  """
  def delete_collaborator(%Collaborator{} = collaborator) do
    Repo.delete(collaborator)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collaborator changes.

  ## Examples

      iex> change_collaborator(collaborator)
      %Ecto.Changeset{data: %Collaborator{}}

  """
  def change_collaborator(%Collaborator{} = collaborator, attrs \\ %{}) do
    Collaborator.changeset(collaborator, attrs)
  end

  @doc """
  Returns the list of collaborators belonging to a department.

  ## Examples

      iex> list_collaborators_by_department_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%Collaborator{}, ...]

  """
  def list_collaborators_by_department_id(id, preloads \\ []) do
    Collaborator
    |> apply_filters(preloads)
    |> where([c], c.department_id == ^id)
    |> Repo.all()
  end
end
