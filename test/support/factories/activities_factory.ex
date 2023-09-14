defmodule Atomic.Factories.ActivityFactory do
  @moduledoc """
  A factory to generate account related structs
  """

  alias Atomic.Activities.{Activity, ActivityEnrollment}

  defmacro __using__(_opts) do
    quote do
      def activity_factory do
        %Activity{
          title: Faker.Beer.brand(),
          description: Faker.Lorem.paragraph(),
          minimum_entries: Enum.random(1..10),
          maximum_entries: Enum.random(11..20),
          start: NaiveDateTime.utc_now(),
          finish: NaiveDateTime.utc_now() |> NaiveDateTime.add(1, :hour)
        }
      end

      def enrollment_factory do
        %ActivityEnrollment{
          present: Enum.random([true, false]),
          activity: build(:activity),
          user: build(:user)
        }
      end
    end
  end
end
