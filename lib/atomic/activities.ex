defmodule Atomic.Activities do
  @moduledoc """
  The Activities context.
  """
  use Atomic.Context

  alias Atomic.Accounts.User
  alias Atomic.Activities.Activity
  alias Atomic.Activities.ActivityEnrollment
  alias Atomic.Activities.Speaker

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

      iex> list_activities_by_organization_id((99d7c9e5-4212-4f59-a097-28aaa33c2621, opts)
      [%Activity{}, ...]

      iex> list_activities_by_organization_id((99d7c9e5-4212-4f59-a097-28aaa33c2621, opts)
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
    total_enrolled = get_total_enrolled(activity_id)

    activity.maximum_entries > total_enrolled
  end

  @doc """
    Verifies if an user is enrolled in an activity.

    ## Examples

        iex> is_participating?(activity_id, user_id)
        true

        iex> is_participating?(activity_id, user_id)
        false
  """
  def is_participating?(activity_id, user_id) do
    ActivityEnrollment
    |> where(activity_id: ^activity_id, user_id: ^user_id)
    |> Repo.exists?()
  end

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
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
      [%ActivityEnrollment{}, ...]

  """
  def list_enrollments do
    Repo.all(ActivityEnrollment)
  end

  @doc """
  Gets a single enrollment.

  Raises `Ecto.NoResultsError` if the ActivityEnrollment does not exist.

  ## Examples

      iex> get_enrollment!(123)
      %ActivityEnrollment{}

      iex> get_enrollment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_enrollment!(id), do: Repo.get!(ActivityEnrollment, id)

  def get_enrollment!(activity_id, user_id) do
    ActivityEnrollment
    |> where(activity_id: ^activity_id, user_id: ^user_id)
    |> Repo.one()
  end

  @doc """
   Gets the user enrolled in an given activity.

    ## Examples

        iex> get_user_enrolled(user, activity_id)
        %ActivityEnrollment{}

        iex> get_user_enrolled(user, activity_id)
        ** (Ecto.NoResultsError)
  """
  def get_user_enrolled(user, activity_id) do
    ActivityEnrollment
    |> where(user_id: ^user.id, activity_id: ^activity_id)
    |> Repo.one()
    |> case do
      nil -> create_enrollment(activity_id, user)
      enrollment -> enrollment
    end
  end

  @doc """
   Gets all user enrollments.

    ## Examples

        iex> list_user_enrollments(user)
        [%ActivityEnrollment{}, ...]

        iex> list_user_enrollments(user)
        ** (Ecto.NoResultsError)
  """
  def list_user_enrollments(user_id) do
    ActivityEnrollment
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  @doc """
  Returns the list of activities a user has enrolled in.

  ## Examples

      iex> list_user_activities(user_id)
      [%Activity{}, ...]
  """
  def list_user_activities(user_id, %{} = flop, opts) when is_list(opts) do
    from(a in Activity,
      join: e in assoc(a, :activity_enrollments),
      where: e.user_id == ^user_id
    )
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Activity)
  end

  @doc """
  Creates an enrollment.

  ## Examples

      iex> create_enrollment(activity_id, %User{} = user)
      {:ok, %ActivityEnrollment{}}

      iex> create_enrollment(activity_id, %User{} = user)
      {:error, %Ecto.Changeset{}}

  """
  def create_enrollment(activity_id, %User{} = user) do
    %ActivityEnrollment{}
    |> ActivityEnrollment.changeset(%{
      activity_id: activity_id,
      user_id: user.id
    })
    |> Repo.insert()
    |> broadcast(:new_enrollment)
  end

  @doc """
  Updates a enrollment.

  ## Examples

      iex> update_enrollment(enrollment, %{field: new_value})
      {:ok, %ActivityEnrollment{}}

      iex> update_enrollment(enrollment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_enrollment(%ActivityEnrollment{} = enrollment, attrs) do
    enrollment
    |> ActivityEnrollment.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a enrollment.

  ## Examples

      iex> delete_enrollment(activity_id, %User{})
      {:ok, %ActivityEnrollment{}}

      iex> delete_enrollment(activity_id, %User{})
      {:error, %Ecto.Changeset{}}

  """
  def delete_enrollment(activity_id, %User{} = user) do
    Repo.delete_all(
      from e in ActivityEnrollment,
        where: e.user_id == ^user.id and e.activity_id == ^activity_id
    )
    |> broadcast(:deleted_enrollment)
  end

  @doc """
  Returns the total number of enrolled users in an activity.

  ## Examples

      iex> get_total_enrolled(activity_id)
      10

      iex> get_total_enrolled(activity_id)
      0
  """
  def get_total_enrolled(activity_id) do
    ActivityEnrollment
    |> where(activity_id: ^activity_id)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking enrollment changes.

  ## Examples

      iex> change_enrollment(enrollment)
      %Ecto.Changeset{data: %ActivityEnrollment{}}

  """
  def change_enrollment(%ActivityEnrollment{} = enrollment, attrs \\ %{}) do
    ActivityEnrollment.changeset(enrollment, attrs)
  end

  @doc """
  Broadcasts an event to the pubsub.

  ## Examples

      iex> broadcast(:new_enrollment, enrollment)
      {:ok, %ActivityEnrollment{}}

      iex> broadcast(:deleted_enrollment, nil)
      {:ok, nil}

  """
  def subscribe(topic) when topic in ["new_enrollment", "deleted_enrollment"] do
    Phoenix.PubSub.subscribe(Atomic.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %ActivityEnrollment{} = enrollment}, event)
       when event in [:new_enrollment] do
    Phoenix.PubSub.broadcast!(Atomic.PubSub, "new_enrollment", {event, enrollment})
    {:ok, enrollment}
  end

  defp broadcast({number, nil}, event)
       when event in [:deleted_enrollment] do
    Phoenix.PubSub.broadcast!(Atomic.PubSub, "deleted_enrollment", {event, nil})
    {number, nil}
  end

  @doc """
  Returns the list of speakers.

  ## Examples

      iex> list_speakers()
      [%Speaker{}, ...]

  """
  def list_speakers do
    Repo.all(Speaker)
  end

  @doc """
  Returns the list of speakers belonging to an organization.

  ## Examples

      iex> list_speakers_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621)
      [%Speaker{}, ...]

  """
  def list_speakers_by_organization_id(id) do
    Repo.all(from s in Speaker, where: s.organization_id == ^id)
  end

  @doc """
  Returns the list of speakers in a list of ids.

  ## Examples

      iex> get_speakers([1, 2, 3])
      [%Speaker{}, ...]

      iex> get_speakers([1, 2, 3])
      []
  """
  def get_speakers(nil), do: []

  def get_speakers(ids) do
    Repo.all(from s in Speaker, where: s.id in ^ids)
  end

  @doc """
  Gets a single speaker.

  Raises `Ecto.NoResultsError` if the Speaker does not exist.

  ## Examples

      iex> get_speaker!(123)
      %Speaker{}

      iex> get_speaker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_speaker!(id), do: Repo.get!(Speaker, id)

  @doc """
  Creates a speaker.

  ## Examples

      iex> create_speaker(%{field: value})
      {:ok, %Speaker{}}

      iex> create_speaker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_speaker(attrs \\ %{}) do
    %Speaker{}
    |> Speaker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a speaker.

  ## Examples

      iex> update_speaker(speaker, %{field: new_value})
      {:ok, %Speaker{}}

      iex> update_speaker(speaker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_speaker(%Speaker{} = speaker, attrs) do
    speaker
    |> Speaker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a speaker.

  ## Examples

      iex> delete_speaker(speaker)
      {:ok, %Speaker{}}

      iex> delete_speaker(speaker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_speaker(%Speaker{} = speaker) do
    Repo.delete(speaker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking speaker changes.

  ## Examples

      iex> change_speaker(speaker)
      %Ecto.Changeset{data: %Speaker{}}

  """
  def change_speaker(%Speaker{} = speaker, attrs \\ %{}) do
    Speaker.changeset(speaker, attrs)
  end
end
