defmodule Atomic.Activities do
  @moduledoc """
  The Activities context.
  """
  use Atomic.Context

  alias Atomic.Accounts.User
  alias Atomic.Activities.Activity
  alias Atomic.Activities.Enrollment
  alias Atomic.Feed.Post

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]
  """
  def list_activities(params \\ %{})

  def list_activities(opts) when is_list(opts) do
    Activity
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_activities(flop) do
    Flop.validate_and_run(Activity, flop, for: Activity)
  end

  def list_activities(%{} = flop, opts) when is_list(opts) do
    Activity
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Returns the list of activities belonging to an organization.

  ## Examples

      iex> list_activities_by_organization_id("99d7c9e5-4212-4f59-a097-28aaa33c2621", opts)
      [%Activity{}, ...]

      iex> list_activities_by_organization_id("99d7c9e5-4212-4f59-a097-28aaa33c2621", opts)
      ** (Ecto.NoResultsError)
  """
  def list_activities_by_organization_id(organization_id, params \\ %{})

  def list_activities_by_organization_id(organization_id, opts) when is_list(opts) do
    Activity
    |> where([a], a.organization_id == ^organization_id)
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_activities_by_organization_id(organization_id, flop) do
    Activity
    |> where([a], a.organization_id == ^organization_id)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  def list_activities_by_organization_id(organization_id, %{} = flop, opts) when is_list(opts) do
    Activity
    |> where([a], a.organization_id == ^organization_id)
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Returns the list of activities starting and ending between two given dates.

    ## Examples

        iex> list_activities_from_to(~N[2020-01-01 00:00:00], ~N[2020-01-31 23:59:59])
        [%Activity{}, ...]

        iex> list_activities_from_to(~N[2024-01-01 00:00:00], ~N[2024-01-31 23:59:59])
        ** (Ecto.NoResultsError)
  """
  def list_activities_from_to(start, finish) do
    from(a in Activity,
      where: a.start >= ^start and a.start <= ^finish,
      order_by: [asc: a.start]
    )
    |> Repo.all()
  end

  @doc """
  Returns the list of upcoming activities.

  ## Examples

      iex> list_upcoming_activities()
      [%Activity{}, ...]

      iex> list_upcoming_activities(opts)
      [%Activity{}, ...]
  """
  def list_upcoming_activities(%{} = flop, opts \\ []) do
    Activity
    |> where([a], fragment("? > now()", a.start))
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Returns the list of activities belonging to a list of organizations.

  ## Examples

      iex> list_organizations_activities(organizations)
      [%Activity{}, ...]
  """
  def list_organizations_activities(organizations, %{} = flop, opts \\ [])
      when is_list(organizations) do
    Activity
    |> where([a], a.organization_id in ^Enum.map(organizations, & &1.id))
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id, preloads \\ []) do
    Repo.get!(Activity, id)
    |> Repo.preload(preloads)
  end

  @doc """
  Returns true if the maximum number of enrollments has been reached.

    ## Examples

        iex> verify_maximum_enrollments(activity_id)
        true

        iex> verify_maximum_enrollments(activity_id)
        false
  """
  def verify_maximum_enrollments?(activity_id) do
    activity = get_activity!(activity_id)
    activity.maximum_entries == activity.enrolled
  end

  @doc """
    Verifies if an user is enrolled in an activity.

    ## Examples

        iex> participating?(activity_id, user_id)
        true

        iex> participating?(activity_id, user_id)
        false
  """
  def participating?(activity_id, user_id) do
    Enrollment
    |> where(activity_id: ^activity_id, user_id: ^user_id)
    |> Repo.exists?()
  end

  @doc """
  Creates an activity and its respective post.
  All in one transaction.

  ## Examples

      iex> create_activity_with_post(%{field: value, field: ~N[2020-01-01 00:00:00]})
      {:ok, %Activity{}}

      iex> create_activity_with_post(%{field: value})
      {:error, %Ecto.Changeset{}}

      iex> create_activity_with_post(%{field: bad_value, field: ~N[2020-01-01 00:00:00]})
      {:error, %Ecto.Changeset{}}

      iex> create_activit__with_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity_with_post(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    Multi.new()
    |> Multi.insert(:post, fn _ ->
      %Post{}
      |> Post.changeset(%{
        type: "activity"
      })
    end)
    |> Multi.insert(:activity, fn %{post: post} ->
      %Activity{}
      |> Activity.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:post, post)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activity: activity, post: _post}} ->
        after_save({:ok, activity}, after_save)

      {:error, _reason, changeset, _actions} ->
        {:error, changeset}
    end
  end

  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs, after_save \\ &{:ok, &1}) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end

  @doc """
  Updates a activity image.

  ## Examples

      iex> update_activity_image(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity_image(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity_image(%Activity{} = activity, attrs) do
    activity
    |> Activity.image_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end

  @doc """
  Returns the list of enrollments.

  ## Examples

      iex> list_enrollments()
      [%Enrollment{}, ...]

  """
  def list_enrollments do
    Repo.all(Enrollment)
  end

  @doc """
  Gets a single enrollment.

  Raises `Ecto.NoResultsError` if the Enrollment does not exist.

  ## Examples

      iex> get_enrollment!(123)
      %Enrollment{}

      iex> get_enrollment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_enrollment!(id), do: Repo.get!(Enrollment, id)

  def get_enrollment!(activity_id, user_id) do
    Enrollment
    |> where(activity_id: ^activity_id, user_id: ^user_id)
    |> Repo.one()
  end

  @doc """
   Gets all user enrollments.

    ## Examples

        iex> list_user_enrollments(user)
        [%Enrollment{}, ...]

        iex> list_user_enrollments(user)
        ** (Ecto.NoResultsError)
  """
  def list_user_enrollments(user_id) do
    Enrollment
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  @doc """
  Returns the list of activities a user has enrolled in.

  ## Examples

      iex> list_user_activities(user_id)
      [%Activity{}, ...]
  """
  def list_user_activities(user_id, params \\ %{})

  def list_user_activities(user_id, opts) when is_list(opts) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_user_activities(user_id, flop) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> Flop.validate_and_run(flop, for: Activity)
  end

  def list_user_activities(user_id, %{} = flop, opts) when is_list(opts) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Returns the list of upcoming activities a user has enrolled in.

  ## Examples

      iex> list_upcoming_user_activities(user_id)
      [%Activity{}, ...]
  """
  def list_upcoming_user_activities(user_id, params \\ %{})

  def list_upcoming_user_activities(user_id, opts) when is_list(opts) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> where([a], fragment("? > now()", a.start))
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_upcoming_user_activities(user_id, flop) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> where([a], fragment("? > now()", a.start))
    |> Flop.validate_and_run(flop, for: Activity)
  end

  def list_upcoming_user_activities(user_id, %{} = flop, opts) when is_list(opts) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> where([a], fragment("? > now()", a.start))
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Returns the list of past activities a user has enrolled in.

  ## Examples

      iex> list_past_user_activities(user_id)
      [%Activity{}, ...]
  """
  def list_past_user_activities(user_id, params \\ %{})

  def list_past_user_activities(user_id, opts) when is_list(opts) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> where([a], fragment("? < now()", a.start))
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_past_user_activities(user_id, flop) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> where([a], fragment("? < now()", a.start))
    |> Flop.validate_and_run(flop, for: Activity)
  end

  def list_past_user_activities(user_id, %{} = flop, opts) when is_list(opts) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> where([a], fragment("? < now()", a.start))
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Returns the list of activities a user has enrolled in.

  ## Examples

      iex> list_user_activities(user_id)
      [%Activity{}, ...]
  """

  def list_organization_activities(organization_id, params \\ %{})

  def list_organization_activities(organization_id, opts) when is_list(opts) do
    from(a in Activity,
      where: a.organization_id == ^organization_id
    )
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_organization_activities(organization_id, flop) do
    from(a in Activity,
      where: a.organization_id == ^organization_id
    )
    |> Flop.validate_and_run(flop, for: Activity)
  end

  def list_organization_activities(organization_id, %{} = flop, opts) when is_list(opts) do
    from(a in Activity,
      where: a.organization_id == ^organization_id
    )
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Returns the count of upcoming activities a user has enrolled in.

  ## Examples

      iex> user_upcoming_activities_count(user_id)
      1
  """
  def user_upcoming_activities_count(user_id) do
    from(a in Activity,
      join: e in assoc(a, :enrollments),
      where: e.user_id == ^user_id
    )
    |> where([a], fragment("? > now()", a.start))
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Creates an enrollment and broadcasts .

  ## Examples

      iex> create_enrollment(activity_id, %User{} = user)
      {:ok, %Enrollment{}}

      iex> create_enrollment(activity_id, %User{} = user)
      {:error, %Ecto.Changeset{}}

  """
  def create_enrollment(activity_id, %User{} = user) do
    %Enrollment{}
    |> Enrollment.changeset(%{activity_id: activity_id, user_id: user.id})
    |> Repo.insert()
    |> case do
      {:ok, enrollment} ->
        broadcast({:ok, enrollment}, :new_enrollment)
        {:ok, enrollment}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a enrollment.

  ## Examples

      iex> update_enrollment(enrollment, %{field: new_value})
      {:ok, %Enrollment{}}

      iex> update_enrollment(enrollment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_enrollment(%Enrollment{} = enrollment, attrs) do
    enrollment
    |> Enrollment.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a enrollment.

  ## Examples

      iex> delete_enrollment(activity_id, %User{})
      {:ok, %Enrollment{}}

      iex> delete_enrollment(activity_id, %User{})
      {:error, %Ecto.Changeset{}}

  """
  def delete_enrollment(activity_id, %User{} = user) do
    get_enrollment!(activity_id, user.id)
    |> Enrollment.changeset(%{})
    |> Repo.delete()
    |> case do
      {:ok, _} ->
        broadcast({1, nil}, :deleted_enrollment)
        {:ok, nil}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking enrollment changes.

  ## Examples

      iex> change_enrollment(enrollment)
      %Ecto.Changeset{data: %Enrollment{}}

  """
  def change_enrollment(%Enrollment{} = enrollment, attrs \\ %{}) do
    Enrollment.changeset(enrollment, attrs)
  end

  @doc """
  Broadcasts an event to the pubsub.

  ## Examples

      iex> broadcast(:new_enrollment, enrollment)
      {:ok, %Enrollment{}}

      iex> broadcast(:deleted_enrollment, nil)
      {:ok, nil}

  """
  def subscribe(topic) when topic in ["new_enrollment", "deleted_enrollment"] do
    Phoenix.PubSub.subscribe(Atomic.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Enrollment{} = enrollment}, event)
       when event in [:new_enrollment] do
    Phoenix.PubSub.broadcast!(Atomic.PubSub, "new_enrollment", {event, enrollment})
    {:ok, enrollment}
  end

  defp broadcast({number, nil}, event)
       when event in [:deleted_enrollment] do
    Phoenix.PubSub.broadcast!(Atomic.PubSub, "deleted_enrollment", {event, nil})
    {number, nil}
  end
end
