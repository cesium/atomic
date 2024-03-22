defmodule Atomic.Partners do
  @moduledoc """
  The Partners context.
  """
  use Atomic.Context

  alias Atomic.Organizations.Partner

  @doc """
  Returns the list of partners.

  ## Examples

      iex> list_partners()
      [%Partner{}, ...]

  """
  def list_partners do
    Repo.all(Partner)
  end

  def list_partners(%{} = flop, opts) when is_list(opts) do
    Partner
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Partner)
  end

  @doc """
  Returns the list of partners belonging to an organization.

  ## Examples

      iex> list_partners_by_organization_id("99d7c9e5-4212-4f59-a097-28aaa33c2621")
      [%Partner{}, ...]

  """
  def list_partners_by_organization_id(id) do
    Repo.all(from p in Partner, where: p.organization_id == ^id)
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
  def get_partner!(id, preloads \\ []), do: Repo.get!(Partner, id)

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
end
