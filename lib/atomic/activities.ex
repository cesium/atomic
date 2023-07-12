defmodule Atomic.Activities do
  @moduledoc """
  The Activities context.
  """
  use Atomic.Context

  alias Atomic.Accounts.User
  alias Atomic.Activities.Activity

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

  alias Atomic.Activities.Enrollment

  def is_participating?(activity_id, user_id) do
    Enrollment
    |> where(activity_id: ^activity_id, user_id: ^user_id)
    |> Repo.one()
    |> case do
      nil -> false
      _ -> true
    end
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

  alias Atomic.Activities.Session

  @doc """
  Returns the list of sessions.

  ## Examples

      iex> list_sessions()
      [%Session{}, ...]

  """
  def list_sessions do
    Repo.all(Session)
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
  def get_session!(id), do: Repo.get!(Session, id)

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

  alias Atomic.Activities.Enrollment

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

  def get_user_enrolled(user, activity) do
    enrollment =
      Enrollment
      |> where(user_id: ^user.id, activity_id: ^activity.id)
      |> Repo.one()

    case enrollment do
      nil -> create_enrollment(activity, user)
      _ -> enrollment
    end
  end

  @doc """
  Creates an enrollment.

  ## Examples

      iex> create_enrollment(%Activity{} = activity, %User{} = user)
      {:ok, %Enrollment{}}

      iex> create_enrollment(%Activity{} = activity, %User{} = user)
      {:error, %Ecto.Changeset{}}

  """
  def create_enrollment(%Activity{} = activity, %User{} = user) do
    %Enrollment{}
    |> Enrollment.changeset(%{
      activity_id: activity.id,
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

  def is_user_enrolled?(%Activity{} = activity, %User{} = user) do
    Repo.one(
      from e in Enrollment,
        where: e.user_id == ^user.id and e.activity_id == ^activity.id
    )
  end

  @doc """
  Deletes a enrollment.

  ## Examples

      iex> delete_enrollment(enrollment)
      {:ok, %Enrollment{}}

      iex> delete_enrollment(enrollment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_enrollment(%Activity{} = activity, %User{} = user) do
    Repo.delete_all(
      from e in Enrollment,
        where: e.user_id == ^user.id and e.activity_id == ^activity.id
    )
    |> broadcast(:deleted_enrollment)
  end

  def get_total_enrolled(%Activity{} = activity) do
    Enrollment
    |> where(activity_id: ^activity.id)
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

  def enrolled?(%Activity{} = activity, %User{} = user) do
    Repo.one(
      from e in Enrollment,
        where: e.user_id == ^user.id and e.activtiy_id == ^activity.id
    )
  end

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

  alias Atomic.Activities.Speaker

  @doc """
  Returns the list of speakers.

  ## Examples

      iex> list_speakers()
      [%Speaker{}, ...]

  """
  def list_speakers do
    Repo.all(Speaker)
  end

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
