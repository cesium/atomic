defmodule Atomic.News do
  @moduledoc """
  The news context.
  """

  alias Atomic.News.New
  alias Atomic.Repo

  @doc """
  Returns the list of news.

  ## Examples

      iex> list_news()
      [%New{}, ...]

  """
  def list_news do
    Repo.all(New)
  end

  @doc """
  Returns the list of news belonging to an organization.

  ## Examples

      iex> list_news_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%New{}, ...]

  """
  def list_news_by_organization_id(id) do
    Repo.all(New)
    |> Enum.filter(fn new -> new.organization_id == id end)
  end

  @doc """
  Gets a single new.

  Raises `Ecto.NoResultsError` if the new does not exist.

  ## Examples

      iex> get_new!(123)
      %New{}

      iex> get_new!(456)
      ** (Ecto.NoResultsError)

  """
  def get_new!(id), do: Repo.get!(New, id)

  @doc """
  Creates a new.

  ## Examples

      iex> create_new(%{field: value})
      {:ok, %New{}}

      iex> create_new(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_new(attrs \\ %{}, _after_save \\ &{:ok, &1}) do
    %New{}
    |> New.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a new.

  ## Examples

      iex> update_new(new, %{field: new_value})
      {:ok, %New{}}

      iex> update_new(new, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_new(%New{} = new, attrs, _after_save \\ &{:ok, &1}) do
    new
    |> New.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a new.

  ## Examples

      iex> delete_new(New)
      {:ok, %New{}}

      iex> delete_new(New)
      {:error, %Ecto.Changeset{}}

  """
  def delete_new(%New{} = new) do
    Repo.delete(new)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking new changes.

  ## Examples

      iex> change_new(new)
      %Ecto.Changeset{data: %New{}}

  """
  def change_new(%New{} = new, attrs \\ %{}) do
    New.changeset(new, attrs)
  end
end
