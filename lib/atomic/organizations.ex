defmodule Atomic.Organizations do
  @moduledoc """
  The Organizations context.
  """
  use Atomic.Context

  alias Atomic.Accounts.User
  alias Atomic.Organizations.{Announcement, Membership, Organization, UserOrganization}

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """

  def list_organizations(opts) do
    Organization
    |> apply_filters(opts)
    |> Repo.all()
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
    organization =
      Repo.get!(Organization, id)
      |> Repo.preload(preloads)

    organization
  end

  @doc """
  Creates an organization.

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
  Updates an organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value}, nil)
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value}, nil)
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs, _after_save \\ &{:ok, &1}) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates an organization card image.

  ## Examples

      iex> update_card_image(organization, %{card_image: new_value})
      {:ok, %Organization{}}

      iex> update_card_image(organization, %{card_image: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card_image(%Organization{} = organization, attrs) do
    organization
    |> Organization.card_changeset(attrs)
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
    |> where([a], a.organization_id == ^organization_id and a.role != :follower)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_memberships(%{"user_id" => user_id}, preloads) do
    Membership
    |> where([a], a.user_id == ^user_id)
    |> Repo.preload(preloads)
    |> Repo.all()
  end

  @doc """
    Verifies if an user is a member of an organization.

    ## Examples

        iex> is_member_of?(user, organization)
        true

        iex> is_member_of?(user, organization)
        false

  """
  def is_member_of?(%User{} = user, %Organization{} = organization) do
    Membership
    |> where([m], m.user_id == ^user.id and m.organization_id == ^organization.id)
    |> Repo.exists?()
  end

  @doc """
  Gets an user role in an organization.

  ## Examples

      iex> get_role(user_id, organization_id)
      :follower

      iex> get_role(user_id, organization_id)
      :member

      iex> get_role(user_id, organization_id)
      :admin

      iex> get_role(user_id, organization_id)
      :owner

      iex> get_role(user_id, organization_id)
      nil

  """
  def get_role(user_id, organization_id) do
    Membership
    |> where([m], m.user_id == ^user_id and m.organization_id == ^organization_id)
    |> Repo.one()
    |> case do
      nil -> nil
      membership -> membership.role
    end
  end

  @doc """
  Verifies if an user is an admin or owner of an organization that is organizing an activity.

  ## Examples

      iex> is_admin?(user, departments)
      true

      iex> is_admin?(user, departments)
      false

  """
  def is_admin?(_user, []), do: false

  def is_admin?(user, [department | rest]) do
    case get_role(user.id, department.organization_id) do
      :owner -> true
      :admin -> true
      _ -> is_admin?(user, rest)
    end
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
  Gets a single membership by user id and organization id.

  Raises `Ecto.NoResultsError` if the membership does not exist.

  ## Examples

      iex> get_membership_by_userid_and_organization_id!(123, 456, [])
      %Membership{}

      iex> get_membership_by_userid_and_organization_id!(456, 789, [])
      ** (Ecto.NoResultsError)

  """
  def get_membership_by_userid_and_organization_id!(user_id, organization_id, preloads \\ []) do
    Membership
    |> where([m], m.user_id == ^user_id and m.organization_id == ^organization_id)
    |> Repo.one!()
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
    [:follower, :member, :admin, :owner]
    |> Enum.drop_while(fn elem -> elem != role end)
  end

  @doc """
  Returns all roles bigger or equal to the given role.

  ## Examples

      iex> roles_bigger_than_or_equal(:member)
      [:member, :admin, :owner]

  """
  def roles_bigger_than_or_equal(role) do
    [:follower, :member, :admin, :owner]
    |> Enum.drop_while(fn elem -> elem != role end)
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
  Returns an `%Ecto.Changeset{}` for tracking user_organization changes.

  ## Examples

      iex> change_user_organization(user_organization)
      %Ecto.Changeset{data: %UserOrganization{}}

  """
  def change_user_organization(%UserOrganization{} = user_organization, attrs \\ %{}) do
    UserOrganization.changeset(user_organization, attrs)
  end

  @doc """
  Returns the amount of members in an organization.

  ## Examples

      iex> get_total_organization_members(organization_id)
      5

  """
  def get_total_organization_members(organization_id) do
    from(m in Membership, where: m.organization_id == ^organization_id)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Returns the list of announcements.

  ## Examples

      iex> list_announcements()
      [%Announcement{}, ...]

  """
  def list_announcements do
    Repo.all(Announcement)
  end

  @doc """
  Returns the list of announcements belonging to an organization.

  ## Examples

      iex> list_announcements_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%Announcement{}, ...]

  """
  def list_announcements_by_organization_id(id, preloads \\ []) do
    Announcement
    |> apply_filters(preloads)
    |> where(organization_id: ^id)
    |> Repo.all()
  end

  @doc """
  Returns the list of published announcements belonging to an organization.

  ## Examples

      iex> list_published_announcements_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%Announcement{}, ...]

  """
  def list_published_announcements_by_organization_id(id, preloads \\ []) do
    Announcement
    |> apply_filters(preloads)
    |> where(organization_id: ^id)
    |> where([n], fragment("now() > ?", n.publish_at))
    |> order_by([n], desc: n.publish_at)
    |> Repo.all()
  end

  @doc """
  Gets a single announcement.

  Raises `Ecto.NoResultsError` if the announcement does not exist.

  ## Examples

      iex> get_announcement!(123)
      %Announcement{}

      iex> get_announcement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_announcement!(id), do: Repo.get!(Announcement, id)

  @doc """
  Creates an announcement.

  ## Examples

      iex> create_announcement(%{field: value})
      {:ok, %Announcement{}}

      iex> create_announcement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_announcement(attrs \\ %{}, _after_save \\ &{:ok, &1}) do
    %Announcement{}
    |> Announcement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an announcement.

  ## Examples

      iex> update_announcement(announcement, %{field: new_value})
      {:ok, %Announcement{}}

      iex> update_announcement(announcement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_announcement(%Announcement{} = announcement, attrs, _after_save \\ &{:ok, &1}) do
    announcement
    |> Announcement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an announcement.

  ## Examples

      iex> delete_announcement(announcement)
      {:ok, %Announcement{}}

      iex> delete_announcement(announcement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_announcement(%Announcement{} = announcement) do
    Repo.delete(announcement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking announcement changes.

  ## Examples

      iex> change_announcement(announcement)
      %Ecto.Changeset{data: %Announcement{}}

  """
  def change_announcement(%Announcement{} = announcement, attrs \\ %{}) do
    Announcement.changeset(announcement, attrs)
  end
end
