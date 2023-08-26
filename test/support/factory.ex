defmodule Atomic.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Atomic.Repo

  use Atomic.Factories.{
    AccountFactory,
    DepartmentFactory,
    ActivityFactory,
    OrganizationFactory,
    NewsFactory
  }
end
