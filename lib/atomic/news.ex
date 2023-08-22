defmodule Atomic.News do
  @moduledoc """
  The news context.
  """
  use Atomic.Context

  alias Atomic.Organizations.News

  @doc """
  Returns the list of news.

  ## Examples

      iex> list_news()
      [%News{}, ...]

  """
  def list_news do
    Repo.all(News)
  end

  @doc """
  Returns the list of news belonging to an organization.

  ## Examples

      iex> list_news_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%News{}, ...]

  """
  def list_news_by_organization_id(id) do
    Repo.all(News)
    |> Enum.filter(fn new -> new.organization_id == id end)
  end

  @doc """
  Gets a single new.

  Raises `Ecto.NoResultsError` if the new does not exist.

  ## Examples

      iex> get_new!(123)
      %News{}

      iex> get_new!(456)
      ** (Ecto.NoResultsError)

  """
  def get_new!(id), do: Repo.get!(News, id)

  @doc """
  Creates a new.

  ## Examples

      iex> create_new(%{field: value})
      {:ok, %News{}}

      iex> create_new(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_new(attrs \\ %{}, _after_save \\ &{:ok, &1}) do
    %News{}
    |> News.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a new.

  ## Examples

      iex> update_new(new, %{field: new_value})
      {:ok, %News{}}

      iex> update_new(new, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_new(%News{} = new, attrs, _after_save \\ &{:ok, &1}) do
    new
    |> News.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a new.

  ## Examples

      iex> delete_new(News)
      {:ok, %News{}}

      iex> delete_new(News)
      {:error, %Ecto.Changeset{}}

  """
  def delete_new(%News{} = new) do
    Repo.delete(new)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking new changes.

  ## Examples

      iex> change_new(new)
      %Ecto.Changeset{data: %News{}}

  """
  def change_new(%News{} = new, attrs \\ %{}) do
    News.changeset(new, attrs)
  end
end
