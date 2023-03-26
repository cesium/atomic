defmodule Atomic.Organizations do
  @moduledoc """
  The Organizations context.
  """
  use Atomic.Context

  import Ecto.Query, warn: false

  alias Atomic.Repo
  alias Atomic.Accounts.User
  alias Atomic.Organizations.Membership
  alias Atomic.Organizations.Organization

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations do
    Repo.all(Organization)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id, preloads \\ []) do
    Repo.get!(Organization, id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  alias Atomic.Organizations.Department

  @doc """
  Returns the list of departments.

  ## Examples

      iex> list_departments()
      [%Department{}, ...]

  """
  def list_departments(opts) when is_list(opts) do
    Department
    |> apply_filters(opts)
    |> Repo.all()
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
  Deletes a organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{data: %Organization{}}

  """
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end

  def create_membership(attrs) do
    %Membership{}
    |> Membership.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of memberships.

  ## Examples

      iex> list_members(%{"organization_id" => id})
      [%Organization{}, ...]

      iex> list_members(%{"user_id" => id})
      [%Organization{}, ...]

  """
  def list_members(opts) when is_list(opts) do
    Membership
    |> where([m], not (m.role in [:member, :staff, :admin]))
    |> apply_filters(opts)
    |> Repo.all()
  end

  def is_member_of?(%User{} = user, %Organization{} = organization) do
    Membership
    |> where([m], m.user_id == ^user.id and m.organization_id == ^organization.id)
    |> Repo.exists?()
  end

  @doc """
  Gets a single membership.

  Raises `Ecto.NoResultsError` if the membership does not exist.

  ## Examples

      iex> get_membership!(123)
      %membership{}

      iex> get_membership!(456)
      ** (Ecto.NoResultsError)

  """
  def get_membership!(id, preloads \\ []) do
    Membership
    |> Repo.get_by!(id: id)
    |> Repo.preload(preloads)
  end

  @doc """
  Updates an membership.

  ## Examples

      iex> update_membership(membership, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_membership(membership, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_membership(%Membership{} = membership, attrs) do
    membership
    |> Membership.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an membership.

  ## Examples

      iex> delete_membership(membership)
      {:ok, %membership{}}

      iex> delete_membership(membership)
      {:error, %Ecto.Changeset{}}

  """
  def delete_membership(%Membership{} = membership) do
    Repo.delete(membership)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking associaiton changes.

  ## Examples

      iex> change_associaiton(associaiton)
      %Ecto.Changeset{data: %Associaiton{}}

  """
  def change_membership(%Membership{} = membership, attrs \\ %{}) do
    Membership.changeset(membership, attrs)
  end

  def roles_less_than_or_equal(role) do
    case role do
      :follower -> []
      :member -> [:member]
      :staff -> [:member, :admin]
      :admin -> [:member, :staff, :admin]
    end
  end

 alias Atomic.Organizations.Partner

  @doc """
  Returns the list of partnerships.

  ## Examples

      iex> list_partnerships()
      [%Partner{}, ...]

  """
  def list_partners(opts) when is_list(opts) do
    Partner
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Gets a single partner.

  Raises `Ecto.NoResultsError` if the Partner does not exist.

  ## Examples

      iex> get_partner!(123)
      %Partner{}

      iex> get_partner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_partner!(id), do: Repo.get!(Partner, id)

  @doc """
  Creates a partner.

  ## Examples

      iex> create_partner(%{field: value})
      {:ok, %Partner{}}

      iex> create_partner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_partner(attrs \\ %{}, _after_save \\ &{:ok, &1}) do
    %Partner{}
    |> Partner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a partner.

  ## Examples

      iex> update_partner(partner, %{field: new_value})
      {:ok, %Partner{}}

      iex> update_partner(partner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_partner(%Partner{} = partner, attrs, _after_save \\ &{:ok, &1}) do
    partner
    |> Partner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a partner.

  ## Examples

      iex> delete_partner(partner)
      {:ok, %Partner{}}

      iex> delete_partner(partner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_partner(%Partner{} = partner) do
    Repo.delete(partner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking partner changes.

  ## Examples

      iex> change_partner(partner)
      %Ecto.Changeset{data: %Partner{}}

  """
  def change_partner(%Partner{} = partner, attrs \\ %{}) do
    Partner.changeset(partner, attrs)
  end

  def update_image(%Partner{} = partner, attrs) do
    partner
    |> Partner.image_changeset(attrs)
    |> Repo.update()
  end

end
