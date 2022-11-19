defmodule Atomic.DepartmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Departments` context.
  """

  @doc """
  Generate a department.
  """
  def department_fixture(attrs \\ %{}) do
    {:ok, department} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Atomic.Departments.create_department()

    department
  end
end
