defmodule Atomic.Schema do
  @moduledoc """
  The application Schema for all the modules, providing Ecto.UUIDs as default id.
  """
  use Gettext, backend: :atomic

  alias Atomic.Time

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      use Waffle.Ecto.Schema
      use Gettext, backend: :atomic

      import Ecto.Changeset
      import Ecto.Query

      alias Atomic.Uploaders

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      def validate_email_address(changeset, field) do
        changeset
        |> validate_format(
          field,
          ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i,
          message: gettext("must be a valid email")
        )
      end

      def validate_naive_datetime(changeset, field, :future) do
        validate_change(changeset, field, fn _field, value ->
          if NaiveDateTime.compare(value, Time.lisbon_now()) == :lt do
            [{field, gettext("date in the past")}]
          else
            []
          end
        end)
      end

      def validate_naive_datetime(changeset, field, date) do
        validate_change(changeset, field, fn _field, value ->
          if NaiveDateTime.compare(value, date) == :lt do
            [{field, gettext("date requires to be after %{date}", date: date)}]
          else
            []
          end
        end)
      end
    end
  end
end
