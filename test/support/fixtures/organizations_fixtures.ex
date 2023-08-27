defmodule Atomic.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Organizations` context.
  """

  @doc """
  Generate an organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        description: "some description",
        handle: "some_handle",
        name: "some name"
      })
      |> Atomic.Organizations.create_organization()

    organization
  end

  @doc """
  Generate an membership
  """
  def membership_fixture(attrs \\ %{}) do
    {:ok, organization} =
      %{}
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Atomic.Organizations.create_organization()

    {:ok, user} =
      %{}
      |> Enum.into(%{
        email: "test@mail.pt",
        password: "password1234",
        role: :student
      })
      |> Atomic.Accounts.register_user()

    {:ok, membership} =
      attrs
      |> Enum.into(%{
        role: :member,
        created_by_id: user.id,
        user_id: user.id,
        organization_id: organization.id
      })
      |> Atomic.Organizations.create_membership()

    membership
  end

  def board_fixture do
    {:ok, organization} =
      %{
        description: "some description",
        name: "some name"
      }
      |> Atomic.Organizations.create_organization()

    {:ok, board} =
      %{
        year: "2022/2023",
        organization_id: organization.id
      }
      |> Atomic.Board.create_board()

    board
  end

  def board_department_fixture do
    {:ok, organization} =
      %{
        description: "some description",
        name: "some name"
      }
      |> Atomic.Organizations.create_organization()

    {:ok, board} =
      %{
        year: "2022/2023",
        organization_id: organization.id
      }
      |> Atomic.Board.create_board()

    {:ok, board_department} =
      %{
        name: "some name",
        board_id: board.id,
        priority: 1
      }
      |> Atomic.Board.create_board_department()

    board_department
  end

  def user_organization_fixture do
    {:ok, organization} =
      %{
        description: "some description",
        name: "some name"
      }
      |> Atomic.Organizations.create_organization()

    {:ok, board} =
      %{
        year: "2022/2023",
        organization_id: organization.id
      }
      |> Atomic.Board.create_board()

    {:ok, board_department} =
      %{
        name: "some name",
        board_id: board.id,
        priority: 1
      }
      |> Atomic.Board.create_board_department()

    {:ok, user} =
      %{
        email: "test@mail.com",
        password: "password1234",
        role: :student
      }
      |> Atomic.Accounts.register_user()

    {:ok, user_organization} =
      %{
        user_id: user.id,
        board_departments_id: board_department.id,
        role: "some role",
        priority: 1
      }
      |> Atomic.Organizations.create_user_organization()

    user_organization
  end
end
