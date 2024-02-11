defmodule Atomic.Feed do
  @moduledoc """
  The Feed context.
  """
  use Atomic.Context

  alias Atomic.Feed.Post

  @posts_limit 50

  @doc """
  Returns a cursor-based pagination of posts.
  Learn more about why using cursor-based pagination at: https://use-the-index-luke.com/no-offset

  ## Examples

      iex> list_posts_paginated()
      %{entries: [%Post{}], metadata: %{...}}

  """
  def list_posts_paginated(opts \\ []) do
    Post
    |> apply_filters(opts)
    |> preload(activity: :organization, announcement: :organization)
    |> Repo.paginate(cursor_fields: [:inserted_at, :id], limit: @posts_limit)
  end

  def list_next_posts_paginated(cursor_after, opts \\ []) do
    Post
    |> apply_filters(opts)
    |> preload(activity: :organization, announcement: :organization)
    |> Repo.paginate(
      after: cursor_after,
      cursor_fields: [{:inserted_at, :desc}, {:id, :desc}],
      limit: @posts_limit
    )
  end

  @doc """
  Returns a list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}]

  """
  def list_posts(opts \\ []) do
    Post
    |> apply_filters(opts)
    |> preload(activity: :organization, announcement: :organization)
    |> Repo.all()
  end

  @doc """
  Gets a single post.

  Raises if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

  """
  def get_post!(id, opts \\ []) do
    Repo.get!(Post, id)
    |> apply_filters(opts)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, ...}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, ...}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, ...}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns a data structure for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Post{...}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
