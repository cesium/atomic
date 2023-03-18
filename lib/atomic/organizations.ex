defmodule Atomic.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false

  alias Atomic.Repo

  alias Atomic.Organizations.Association
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

  def create_association(attrs) do
    %Association{}
    |> Association.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of associations.

  ## Examples

      iex> list_associations(%{"organization_id" => id})
      [%Organization{}, ...]

      iex> list_associations(%{"user_id" => id})
      [%Organization{}, ...]

  """
  def list_associations(params, preloads \\ [])

  def list_associations(%{"organization_id" => organization_id}, preloads) do
    Association
    |> where([a], a.organization_id == ^organization_id)
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_associations(%{"user_id" => user_id}, preloads) do
    Association
    |> where([a], a.user_id == ^user_id)
    |> Repo.preload(preloads)
    |> Repo.all()
  end

  @doc """
  Gets a single association.

  Raises `Ecto.NoResultsError` if the association does not exist.

  ## Examples

      iex> get_association!(123)
      %Association{}

      iex> get_association!(456)
      ** (Ecto.NoResultsError)

  """
  def get_association!(id, preloads \\ []) do
    Association
    |> Repo.get_by!(id: id)
    |> Repo.preload(preloads)
  end

  @doc """
  Updates an association.

  ## Examples

      iex> update_association(association, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_association(association, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_association(%Association{} = association, attrs) do
    association
    |> Association.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an association.

  ## Examples

      iex> delete_association(association)
      {:ok, %Association{}}

      iex> delete_association(association)
      {:error, %Ecto.Changeset{}}

  """
  def delete_association(%Association{} = association) do
    Repo.delete(association)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking associaiton changes.

  ## Examples

      iex> change_associaiton(associaiton)
      %Ecto.Changeset{data: %Associaiton{}}

  """
  def change_association(%Association{} = association, attrs \\ %{}) do
    Association.changeset(association, attrs)
  end
end
