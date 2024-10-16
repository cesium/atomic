defmodule Atomic.Partners do
  @moduledoc """
  The Partners context.
  """
  use Atomic.Context

  alias Atomic.Organizations.Partner
  alias Atomic.Socials

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
  def create_partner(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    %Partner{}
    |> Partner.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a partner.

  ## Examples

      iex> update_partner(partner, %{field: new_value})
      {:ok, %Partner{}}

      iex> update_partner(partner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_partner(%Partner{} = partner, attrs, after_save \\ &{:ok, &1}) do
    partner
    |> Partner.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end

  @doc """
  Updates a partner's picture.

  ## Examples

      iex> update_partner_picture(partner, %{image: %Plug.Upload{}})
      {:ok, %Partner{}}

      iex> update_partner_picture(partner, %{image: %Plug.Upload{}})
      {:error, %Ecto.Changeset{}}

  """
  def update_partner_picture(%Partner{} = partner, attrs, _after_save \\ &{:ok, &1}) do
    partner
    |> Partner.image_changeset(attrs)
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
  Archives a partner.

  ## Examples

      iex> archive_partner(partner)
      {:ok, %Partner{}}

      iex> archive_partner(partner)
      {:error, %Ecto.Changeset{}}

  """
  def archive_partner(%Partner{} = partner) do
    partner
    |> Partner.changeset(%{archived: true})
    |> Repo.update()
  end

  @doc """
  Unarchives a partner.

  ## Examples

      iex> unarchive_partner(partner)
      {:ok, %Partner{}}

      iex> unarchive_partner(partner)
      {:error, %Ecto.Changeset{}}
  """
  def unarchive_partner(%Partner{} = partner) do
    partner
    |> Partner.changeset(%{archived: false})
    |> Repo.update()
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

  def change_partner_socials(%Socials{} = socials, attrs \\ %{}) do
    Socials.changeset(socials, attrs)
  end
end
