defmodule Atomic.Activities.ActivityDepartment do
  @moduledoc """
    An activity department
  """
  use Atomic.Schema

  alias Atomic.Activities.Activity
  alias Atomic.Departments.Department

  @required_fields ~w(activity_id department_id)a

  schema "activity_departments" do
    belongs_to :activity, Activity
    belongs_to :department, Department

    timestamps()
  end

  def changeset(activity_departments, attrs) do
    activity_departments
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(activity_departments, attrs) do
    activity_departments
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
