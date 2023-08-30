defmodule Atomic.Factories.AccountFactory do
  @moduledoc """
  A factory to generate account related structs
  """

  alias Atomic.Accounts.User

  defmacro __using__(_opts) do
    quote do
      @roles ~w(admin student)a

      def user_factory do
        %User{
          name: Faker.Person.name(),
          email: Faker.Internet.email(),
          slug: Faker.Internet.user_name(),
          role: Enum.random(@roles),
          hashed_password: Bcrypt.hash_pwd_salt("password1234")
        }
      end
    end
  end
end
