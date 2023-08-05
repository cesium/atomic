defmodule Atomic.Activities do
  @moduledoc """
  The Activities context.
  """
  use Atomic.Context

  alias Atomic.Accounts.User
  alias Atomic.Activities.Activity
  alias Atomic.Activities.Enrollment
  alias Atomic.Activities.Session
  alias Atomic.Activities.Speaker

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities(opts)
      [%Activity{}, ...]

  """
  def list_activities(opts) when is_list(opts) do
    Activity
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Returns the list of activities belonging to an organization.

  ## Examples

      iex> list_activities_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621, opts)
      [%Activity{}, ...]

      iex> list_activities_by_organization_id(99d7c9e5-4212-4f59-a097-28aaa33c2621, opts)
      ** (Ecto.NoResultsError)
  """
  def list_activities_by_organization_id(organization_id, opts) when is_list(opts) do
    Activity
    |> apply_filters(opts)
    |> join(:inner, [a], d in assoc(a, :departments))
    |> where([a, d], d.organization_id == ^organization_id)
    |> select([a, _d], a)
    |> Repo.all()
    |> Repo.preload(activity_sessions: :enrollments)
  end

  @doc """
  Returns the list of activity sessions starting and ending between two given dates.

    ## Examples

        iex> list_sessions_from_to(~N[2020-01-01 00:00:00], ~N[2020-01-31 23:59:59], opts)
        [%Session{}, ...]

        iex> list_sessions_from_to(~N[2024-01-01 00:00:00], ~N[2024-01-31 23:59:59], opts)
        ** (Ecto.NoResultsError)
  """
  def list_sessions_from_to(start, finish, opts) do
    from(s in Session,
      join: a in Activity,
      on: s.activity_id == a.id,
      where: s.start >= ^start and s.start <= ^finish,
      order_by: [asc: s.start]
    )
    |> apply_filters(opts)
    |> Repo.all()
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
    Returns the list of organizations ids that are associated with an activity.

    ## Examples

        iex> get_activity_organizations!(activity)
        [19d7c9e5-4212-4f59-a097-28aaa33c2621, ...]

        iex> get_activity_organizations!(activity)
        ** (Ecto.NoResultsError)
  """
  def get_activity_organizations!(activity, preloads \\ [:departments]) do
    Repo.preload(activity, preloads)
    |> Map.get(:departments, [])
    |> Enum.map(& &1.organization_id)
  end

  @doc """
    Verifies if an user is enrolled in an activity session.

    ## Examples

        iex> is_participating?(session_id, user_id)
        true

        iex> is_participating?(session_id, user_id)
        false
  """
  def is_participating?(session_id, user_id) do
    Enrollment
    |> where(session_id: ^session_id, user_id: ^user_id)
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
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
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
  Returns the list of sessions.

  ## Examples

      iex> list_sessions(opts)
      [%Session{}, ...]

  """
  def list_sessions(opts) when is_list(opts) do
    Session
    |> apply_filters(opts)
    |> Repo.all()
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

      iex> get_session!(123)
      %Session{}

      iex> get_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_session!(id, preloads \\ []) do
    Repo.get!(Session, id)
    |> Repo.preload(preloads)
  end

  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{field: value})
      {:ok, %Session{}}

      iex> create_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session.

  ## Examples

      iex> update_session(session, %{field: new_value})
      {:ok, %Session{}}

      iex> update_session(session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a session.

  ## Examples

      iex> delete_session(session)
      {:ok, %Session{}}

      iex> delete_session(session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{data: %Session{}}

  """
  def change_session(%Session{} = session, attrs \\ %{}) do
    Session.changeset(session, attrs)
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

  def get_enrollment!(session_id, user_id) do
    Enrollment
    |> where(session_id: ^session_id, user_id: ^user_id)
    |> Repo.one()
  end

  @doc """
   Gets the user enrolled in an given activity session.

    ## Examples

        iex> get_user_enrolled(user, session_id)
        %Enrollment{}

        iex> get_user_enrolled(user, session_id)
        ** (Ecto.NoResultsError)
  """
  def get_user_enrolled(user, session_id) do
    Enrollment
    |> where(user_id: ^user.id, session_id: ^session_id)
    |> Repo.one()
    |> case do
      nil -> create_enrollment(session_id, user)
      enrollment -> enrollment
    end
  end

  @doc """
   Gets all user enrollments.

    ## Examples

        iex> get_user_enrollments(user)
        [%Enrollment{}, ...]

        iex> get_user_enrollments(user)
        ** (Ecto.NoResultsError)
  """
  def get_user_enrollments(user_id) do
    Enrollment
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def get_user_activities(user_id) do
    activities_ids =
      get_user_enrollments(user_id)
      |> Enum.map(& &1.activity_id)

    for activity_id <- activities_ids,
        do:
          get_activity!(activity_id)
          |> Repo.preload([:enrollments, :activity_sessions, :speakers])
  end

  @doc """
  Creates an enrollment.

  ## Examples

      iex> create_enrollment(session_id, %User{} = user)
      {:ok, %Enrollment{}}

      iex> create_enrollment(session_id, %User{} = user)
      {:error, %Ecto.Changeset{}}

  """
  def create_enrollment(session_id, %User{} = user) do
    %Enrollment{}
    |> Enrollment.changeset(%{
      session_id: session_id,
      user_id: user.id
    })
    |> Repo.insert()
    |> broadcast(:new_enrollment)
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
    |> Enrollment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a enrollment.

  ## Examples

      iex> delete_enrollment(session_id, %User{})
      {:ok, %Enrollment{}}

      iex> delete_enrollment(session_id, %User{})
      {:error, %Ecto.Changeset{}}

  """
  def delete_enrollment(session_id, %User{} = user) do
    Repo.delete_all(
      from e in Enrollment,
        where: e.user_id == ^user.id and e.session_id == ^session_id
    )
    |> broadcast(:deleted_enrollment)
  end

  @doc """
  Returns the total number of enrolled users in an activity session.

  ## Examples

      iex> get_total_enrolled(session_id)
      10

      iex> get_total_enrolled(session_id)
      0
  """
  def get_total_enrolled(session_id) do
    Enrollment
    |> where(session_id: ^session_id)
    |> Repo.aggregate(:count, :id)
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
