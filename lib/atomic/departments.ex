defmodule Atomic.Departments do
  @moduledoc """
  The Departments context.
  """
  use Atomic.Context

  alias Atomic.Accounts.User
  alias Atomic.Organizations.{Collaborator, Department}
  alias AtomicWeb.DepartmentEmails
  alias AtomicWeb.Router.Helpers

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

      iex> list_departments_by_organization_id("99d7c9e5-4212-4f59-a097-28aaa33c2621")
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

      iex> get_departments([
      ...>   "99d7c9e5-4212-4f59-a097-28aaa33c2621",
      ...>   "99d7c9e5-4212-4f59-a097-28aaa33c2621"
      ...> ])
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
  def create_department(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    %Department{}
    |> Department.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a department.

  ## Examples

      iex> update_department(department, %{field: new_value})
      {:ok, %Department{}}

      iex> update_department(department, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_department(%Department{} = department, attrs, after_save \\ &{:ok, &1}) do
    department
    |> Department.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
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
  Archives a department.

  ## Examples

      iex> archive_department(department)
      {:ok, %Department{}}

      iex> archive_department(department)
      {:error, %Ecto.Changeset{}}

  """
  def archive_department(%Department{} = department) do
    department
    |> Department.changeset(%{archived: true})
    |> Repo.update()
  end

  @doc """
  Unarchives a department.

  ## Examples

      iex> unarchive_department(department)
      {:ok, %Department{}}

      iex> unarchive_department(department)
      {:error, %Ecto.Changeset{}}

  """
  def unarchive_department(%Department{} = department) do
    department
    |> Department.changeset(%{archived: false})
    |> Repo.update()
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

      iex> list_collaborators_by_organization_id("99d7c9e5-4212-4f59-a097-28aaa33c2621")
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
  def get_collaborator!(id, opts \\ []) do
    Collaborator
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

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
  Accepts a collaborator.

  ## Examples

      iex> accept_collaborator(collaborator)
      {:ok, %Collaborator{}}

      iex> accept_collaborator(collaborator)
      {:error, %Ecto.Changeset{}}

  """
  def accept_collaborator(%Collaborator{} = collaborator) do
    collaborator
    |> Collaborator.changeset(%{accepted: true, accepted_at: NaiveDateTime.utc_now()})
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
  Returns a paginated list of collaborators.

  ## Examples

      iex> list_display_collaborators()
      [%Collaborator{}, ...]

  """
  def list_display_collaborators(%{} = flop, opts \\ []) do
    Collaborator
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Collaborator)
  end

  @doc """
  Returns the list of collaborators belonging to a department.

  ## Examples

      iex> list_collaborators_by_department_id("99d7c9e5-4212-4f59-a097-28aaa33c2621")
      [%Collaborator{}, ...]

  """
  def list_collaborators_by_department_id(id, opts \\ []) do
    Collaborator
    |> apply_filters(opts)
    |> where([c], c.department_id == ^id)
    |> Repo.all()
  end

  @doc """
  Updates a department banner.

  ## Examples

      iex> update_department_banner(department, %{field: new_value})
      {:ok, %Department{}}

      iex> update_department_banner(department, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_department_banner(%Department{} = department, attrs) do
    department
    |> Department.banner_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Get all admins of an organization that are collaborators of a department.

  ## Examples

      iex> get_admin_collaborators(department)
      [%User{}, ...]

  """
  def get_admin_collaborators(%Department{} = department) do
    User
    |> join(:inner, [u], c in assoc(u, :collaborators))
    |> where([u, c], c.department_id == ^department.id and c.accepted == true)
    |> join(:inner, [u, c], m in assoc(u, :memberships))
    |> where(
      [u, c, m],
      m.organization_id == ^department.organization_id and m.role in [:admin, :owner]
    )
    |> Repo.all()
  end

  @doc """
  Request collaborator access and send email.

  ## Examples

      iex> request_collaborator_access(user, department)
      {:ok, %Collaborator{}}

      iex> request_collaborator_access(user, department)
      {:error, %Ecto.Changeset{}}

  """
  def request_collaborator_access(%User{} = user, %Department{} = department) do
    case create_collaborator(%{department_id: department.id, user_id: user.id}) do
      {:ok, %Collaborator{} = collaborator} ->
        DepartmentEmails.send_collaborator_request_email(
          collaborator |> Repo.preload(:user),
          department,
          Helpers.department_show_path(
            AtomicWeb.Endpoint,
            :edit_collaborator,
            department.organization_id,
            department,
            collaborator,
            tab: "collaborators"
          ),
          to: get_admin_collaborators(department) |> Enum.map(& &1.email)
        )

        {:ok, collaborator}

      error ->
        error
    end
  end

  @doc """
  Accept collaborator request and send email.

  ## Examples

      iex> accept_collaborator_request(collaborator)
      {:ok, %Collaborator{}}

      iex> accept_collaborator_request(collaborator)
      {:error, %Ecto.Changeset{}}

  """
  def accept_collaborator_request(%Collaborator{} = collaborator) do
    collaborator
    |> Repo.preload(department: [:organization])
    |> accept_collaborator()
    |> case do
      {:ok, collaborator} ->
        DepartmentEmails.send_collaborator_accepted_email(
          collaborator,
          collaborator.department,
          Helpers.department_show_path(
            AtomicWeb.Endpoint,
            :show,
            collaborator.department.organization,
            collaborator.department
          ),
          to: collaborator.user.email
        )

      error ->
        error
    end
  end
end
