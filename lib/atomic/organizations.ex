defmodule Atomic.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false

  use Atomic.Context

  alias Atomic.Organizations.UserOrganization
  alias Atomic.Repo
  alias Atomic.Accounts.User
  alias Atomic.Organizations.Membership
  alias Atomic.Organizations.Organization
  alias Atomic.Organizations.UserOrganization

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

  @doc """
  Creates a membership.

  ## Examples

      iex> create_membership(%{field: value})
      {:ok, %Membership{}}

      iex> create_membership(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_membership(attrs) do
    %Membership{}
    |> Membership.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of memberships.

  ## Examples

      iex> list_memberships(%{"organization_id" => id})
      [%Organization{}, ...]

      iex> list_memberships(%{"user_id" => id})
      [%Organization{}, ...]

  """
  def list_memberships(params, preloads \\ [])

  def list_memberships(%{"organization_id" => organization_id}, preloads) do
    Membership
    |> where([a], a.organization_id == ^organization_id)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_memberships(%{"user_id" => user_id}, preloads) do
    Membership
    |> where([a], a.user_id == ^user_id)
    |> Repo.preload(preloads)
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
  Returns an `%Ecto.Changeset{}` for tracking association changes.

  ## Examples

      iex> change_association(association)
      %Ecto.Changeset{data: %Association{}}

  """
  def change_membership(%Membership{} = membership, attrs \\ %{}) do
    Membership.changeset(membership, attrs)
  end

  @doc """
  Returns all roles lower or equal to the given role.

  Follower is not considered a role for the purposes of this function

  ## Examples

      iex> roles_less_than_or_equal(:member)
      [:member]

  """
  def roles_less_than_or_equal(role) do
    case role do
      :follower -> []
      :member -> [:member]
      :admin -> [:member, :admin]
      :owner -> [:member, :admin, :owner]
    end
  end

  @doc """
  Returns the list of users organizations.

  ## Examples

      iex> list_users_organizations()
      [%UserOrganization{}, ...]

      iex> list_users_organizations()
      [%UserOrganization{}, ...]

  """
  def list_users_organizations(opts \\ [], preloads \\ []) do
    UserOrganization
    |> apply_filters(opts)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  @doc """
  Gets a single user organization.

  Raises `Ecto.NoResultsError` if the user organization does not exist.

  ## Examples

      iex> get_user_organization!(123)
      %UserOrganization{}

      iex> get_user_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_organization!(id, preloads \\ []) do
    Repo.get!(UserOrganization, id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates an user organization.

  ## Examples

      iex> create_user_organization(%{field: value})
      {:ok, %UserOrganization{}}

      iex> create_user_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_organization(attrs) do
    %UserOrganization{}
    |> UserOrganization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an user organization.

  ## Examples

      iex> update_user_organization(user_organization, %{field: new_value})
      {:ok, %UserOrganization{}}

      iex> update_user_organization(user_organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_organization(%UserOrganization{} = user_organization, attrs) do
    user_organization
    |> UserOrganization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an user organization.

  ## Examples

      iex> delete_user_organization(user_organization)
      {:ok, %UserOrganization{}}

      iex> delete_user_organization(user_organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_organization(%UserOrganization{} = user_organization) do
    Repo.delete(user_organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_association changes.

  ## Examples

      iex> change_user_organization(user_organization)
      %Ecto.Changeset{data: %UserOrganization{}}

  """
  def change_user_organization(%UserOrganization{} = user_organization, attrs \\ %{}) do
    UserOrganization.changeset(user_organization, attrs)
  end
end
