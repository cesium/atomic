defmodule Atomic.Accounts.User do
  @moduledoc """
  A user of the application capable of authenticating.
  """
  use Atomic.Schema

  alias Atomic.Accounts.Course
  alias Atomic.Activities.Enrollment
  alias Atomic.Organizations.{Membership, Organization}
  alias Atomic.Uploaders.ProfilePicture

  @required_fields ~w(email password)a
  @optional_fields ~w(name slug role phone_number confirmed_at course_id default_organization_id)a

  @roles ~w(admin student)a

  schema "users" do
    field :name, :string
    field :email, :string
    field :slug, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime

    field :phone_number, :string
    field :profile_picture, ProfilePicture.Type
    field :role, Ecto.Enum, values: @roles, default: :student
    belongs_to :course, Course
    belongs_to :default_organization, Organization

    has_many :enrollments, Enrollment
    many_to_many :organizations, Organization, join_through: Membership

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_email()
    |> validate_password(opts)
  end

  def picture_changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, [:profile_picture])
  end

  @doc """
    A user changeset for updating the user.
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_email()
    |> validate_slug()
    |> validate_phone_number()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Atomic.Repo)
    |> unique_constraint(:email)
  end

  defp validate_slug(changeset) do
    changeset
    |> validate_required([:slug])
    |> validate_format(:slug, ~r/^[a-zA-Z0-9_.]+$/,
      message:
        gettext("must only contain alphanumeric characters, numbers, underscores and periods")
    )
    |> validate_length(:slug, min: 3, max: 30)
    |> unsafe_validate_unique(:slug, Atomic.Repo)
    |> unique_constraint(:slug)
  end

  defp validate_phone_number(changeset) do
    changeset
    |> validate_format(:phone_number, ~r/^\+?[1-9][0-9]{7,14}$/,
      message: gettext("must be a valid phone number")
    )
    |> validate_length(:phone_number, min: 9, max: 13)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for initial account setup.
  """
  def setup_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :slug, :course_id])
    |> validate_slug()
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the slug.

  It requires the slug to change otherwise an error is added.
  """
  def slug_changeset(user, attrs) do
    user
    |> cast(attrs, [:slug])
    |> validate_slug()
    |> case do
      %{changes: %{slug: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :slug, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Atomic.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
