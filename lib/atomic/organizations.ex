defmodule Atomic.Organizations do
  @moduledoc """
  The Organizations context.
  """
  use Atomic.Context

  alias Atomic.Accounts.User
  alias Atomic.Feed.Post
  alias Atomic.Organizations.{Announcement, Membership, Organization}

  ## Organizations

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations(params \\ %{})

  def list_organizations(opts) when is_list(opts) do
    Organization
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_organizations(flop) do
    Flop.validate_and_run(Organization, flop, for: Organization)
  end

  def list_organizations(%{} = flop, opts) when is_list(opts) do
    Organization
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Organization)
  end

  @doc """
  Returns a list of organizations that are not followed by an user, ordered by the amount of followers.

  ## Examples

      iex> list_top_organizations_for_user(user)
      [%Organization{}, ...]

  """
  def list_top_organizations_for_user(%User{} = user, opts \\ []) do
    Organization
    |> join(:inner, [o], m in Membership, on: m.organization_id == o.id)
    |> where([o, m], m.user_id != ^user.id and m.role == :follower)
    |> group_by([o], o.id)
    |> select([o], %{organization: o, count: count(o.id)})
    |> order_by([o], desc: o.count)
    |> apply_filters(opts)
    |> Repo.all()
    |> Enum.map(fn %{organization: organization} -> organization end)
  end

  @doc """
  Returns a list of the top organizations, ordered by the amount of followers.

  ## Examples

      iex> list_top_organizations()
      [%Organization{}, ...]

  """
  def list_top_organizations(opts) when is_list(opts) do
    Organization
    |> join(:inner, [o], m in Membership, on: m.organization_id == o.id)
    |> where([o, m], m.role == :follower)
    |> group_by([o], o.id)
    |> select([o], %{organization: o, count: count(o.id)})
    |> order_by([o], desc: o.count)
    |> apply_filters(opts)
    |> Repo.all()
    |> Enum.map(fn %{organization: organization} -> organization end)
  end

  @doc """
  Returns a list of the top organizations that are not followed by an user, ordered by the amount of followers.

  ## Examples

      iex> list_top_not_followed_organization(user_id)
      [%Organization{}, ...]

  """
  def list_top_not_followed_organization(user_id, opts) when is_list(opts) do
    Organization
    |> join(:left, [o], m in Membership, on: m.organization_id == o.id and m.user_id == ^user_id)
    |> where([o, m], m.role != :follower or is_nil(m.id))
    |> group_by([o], o.id)
    |> select([o], %{organization: o, count: count(o.id)})
    |> order_by([o], desc: o.count)
    |> apply_filters(opts)
    |> Repo.all()
    |> Enum.map(fn %{organization: organization} -> organization end)
  end

  @doc """
  Returns the list of organizations members.

  ## Examples

      iex> list_organizations()
      [%Membership{}, ...]

  """
  def list_organizations_members(%Organization{} = organization) do
    from(m in Membership,
      where: m.organization_id == ^organization.id and m.role != :follower,
      join: u in User,
      on: u.id == m.user_id,
      select: u
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of organizations followed by an user.

  ## Examples

      iex> list_organizations_followed_by_user(user_id)
      [%Organization{}, ...]

  """
  def list_organizations_followed_by_user(user_id) do
    Organization
    |> join(:inner, [o], m in Membership, on: m.organization_id == o.id)
    |> where([o, m], m.user_id == ^user_id and m.role == :follower)
    |> Repo.all()
  end

  @doc """
  Returns the list of organizations which are connected with the user.
  By default, it returns the organizations where the user is an admin or owner.

  ## Examples

      iex> list_user_organizations(123)
      [%Organization{}, ...]

      iex> list_user_organizations(456)
      []

      iex> list_user_organizations(123, [:follower])
      [%Organization{}, ...]

  """
  def list_user_organizations(user_id, roles \\ [:admin, :owner], opts \\ []) do
    Organization
    |> join(:inner, [o], m in Membership, on: m.organization_id == o.id)
    |> where([o, m], m.user_id == ^user_id and m.role in ^roles)
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
    Repo.get!(Organization, id)
    |> Repo.preload(preloads)
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

  ## Memberships

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
  Returns the list of members in an organization.
  A member is someone who is connected to the organization with a role other than `:follower`.

  ## Examples

      iex> list_memberships(123)
      [%Organization{}, ...]

  """
  def list_memberships(organization_id, opts \\ []) do
    Membership
    |> where([m], m.organization_id == ^organization_id and m.role != :follower)
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Counts the number of members in an organization.
  A member is someone who is connected to the organization with a role other than `:follower`.

  ## Examples

      iex> count_memberships(123)
      5

      iex> count_memberships(456)
      0

  """
  def count_memberships(organization_id) do
    Membership
    |> where([m], m.organization_id == ^organization_id and m.role != :follower)
    |> Repo.count()
  end

  @doc """
  Counts the number of followers in an organization.

  ## Examples

      iex> count_followers(123)
      5

      iex> count_followers(456)
      0

  """
  def count_followers(organization_id) do
    Membership
    |> where([m], m.organization_id == ^organization_id and m.role == :follower)
    |> Repo.count()
  end

  @doc """
  Verifies if an user is a member of an organization.

  ## Examples

      iex> member_of?(user, organization)
      true

      iex> member_of?(user, organization)
      false

  """
  def member_of?(%User{} = user, %Organization{} = organization) do
    Membership
    |> where([m], m.user_id == ^user.id and m.organization_id == ^organization.id)
    |> Repo.exists?()
  end

  @doc """
  Checks if an user is following an organization.

  ## Examples

      iex> user_following?(123, 456)
      true

      iex> user_following?(456, 789)
      false

  """
  def user_following?(user_id, organization_id) do
    Membership
    |> where(
      [m],
      m.user_id == ^user_id and m.organization_id == ^organization_id and m.role == :follower
    )
    |> Repo.exists?()
  end

  @doc """
  Gets an user role in an organization.

  ## Examples

      iex> get_role(user_id, organization_id)
      :follower

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

      iex> get_membership_by_user_id_and_organization_id!(123, 456, [])
      %Membership{}

      iex> get_membership_by_user_id_and_organization_id!(456, 789, [])
      ** (Ecto.NoResultsError)

  """
  def get_membership_by_user_id_and_organization_id!(user_id, organization_id, preloads \\ []) do
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
    organization =
      from(o in Organization, where: o.id == ^membership.organization_id) |> Repo.one()

    if !(organization.name == "CeSIUM" and membership.role == :follower) do
      Repo.delete(membership)
    end
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
  Returns all roles bigger or equal to the given role.

  ## Examples

      iex> roles_bigger_than_or_equal(:follower)
      [:follower, :admin, :owner]

  """
  def roles_bigger_than_or_equal(role) do
    Membership.roles()
    |> Enum.drop_while(fn elem -> elem != role end)
  end

  ## Announcements

  @doc """
  Returns the list of announcements.

  ## Examples

      iex> list_announcements()
      [%Announcement{}, ...]

  """
  def list_announcements(params \\ %{})

  def list_announcements(opts) when is_list(opts) do
    Announcement
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_announcements(flop) do
    Flop.validate_and_run(Announcement, flop, for: Announcement)
  end

  def list_announcements(%{} = flop, opts) when is_list(opts) do
    Announcement
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Announcement)
  end

  @doc """
  Returns the list of announcements belonging to an organization.

  ## Examples

      iex> list_announcements_by_organization_id("99d7c9e5-4212-4f59-a097-28aaa33c2621")
      [%Announcement{}, ...]

  """
  def list_announcements_by_organization_id(id, opts \\ []) do
    Announcement
    |> where(organization_id: ^id)
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Returns the list of announcements belonging to an organization.

  ## Examples

      iex> list_announcements_by_organization_id("99d7c9e5-4212-4f59-a097-28aaa33c2621")
      [%Announcement{}, ...]

  """
  def list_organizations_announcements(organizations, %{} = flop, opts \\ []) do
    Announcement
    |> where([a], a.organization_id in ^Enum.map(organizations, & &1.id))
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Announcement)
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

  def get_announcement!(id, opts) when is_list(opts) do
    Announcement
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

  @doc """
  Creates an announcement and its respective post.
  All in one transaction.

  ## Examples

      iex> create_announcement_with_post(%{field: value}, ~N[2019-01-01 00:00:00])
      {:ok, %Announcement{}}

      iex> create_announcement_with_post(%{field: value})
      {:ok, %Announcement{}}

      iex> create_announcement_with_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_announcement_with_post(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:post, fn _ ->
      %Post{}
      |> Post.changeset(%{
        type: "announcement"
      })
    end)
    |> Multi.insert(:announcement, fn %{post: post} ->
      %Announcement{}
      |> Announcement.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:post, post)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{announcement: announcement, post: _post}} ->
        {:ok, announcement}

      {:error, _reason, changeset, _actions} ->
        {:error, changeset}
    end
  end

  def create_announcement(attrs \\ %{}) do
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
