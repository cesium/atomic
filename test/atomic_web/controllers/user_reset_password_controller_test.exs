defmodule AtomicWeb.UserResetPasswordControllerTest do
  use AtomicWeb.ConnCase, async: true

  alias Atomic.Accounts
  alias Atomic.Repo
  import Atomic.AccountsFixtures

  setup do
    %{user: insert(:user)}
  end

  describe "GET /users/reset_password" do
    test "renders the reset password page", %{conn: conn} do
      conn = get(conn, ~p"/users/reset_password")
      response = html_response(conn, 200)
      assert response =~ "Recover Account"
    end
  end

  describe "POST /users/reset_password" do
    @tag :capture_log
    test "sends a new reset password token given a valid email", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/users/reset_password", %{
          "user" => %{"input" => user.email}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email or username is in our system"

      assert Repo.get_by!(Accounts.UserToken, user_id: user.id).context == "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      post(conn, ~p"/users/reset_password", %{
        "user" => %{"input" => "unknown@example.com"}
      })

      assert Repo.all(Accounts.UserToken) == []
    end

    test "sends a new reset password token given a valid slug", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/users/reset_password", %{
          "user" => %{"input" => user.slug}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email or username is in our system"

      assert Repo.get_by!(Accounts.UserToken, user_id: user.id).context == "reset_password"
    end

    test "does not send reset password token if slug is invalid", %{conn: conn} do
      post(conn, ~p"/users/reset_password", %{
        "user" => %{"input" => "unknown"}
      })

      assert Repo.all(Accounts.UserToken) == []
    end
  end

  describe "GET /users/reset_password/:token" do
    setup %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_reset_password_instructions(user, url)
        end)

      %{token: token}
    end

    test "renders reset password", %{conn: conn, token: token} do
      conn = get(conn, ~p"/users/reset_password/#{token}")
      assert html_response(conn, 200) =~ "Reset Password"
    end
  end

  describe "PUT /users/reset_password/:token" do
    setup %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_reset_password_instructions(user, url)
        end)

      %{token: token}
    end

    test "resets password once", %{conn: conn, user: user, token: token} do
      conn =
        put(conn, ~p"/users/reset_password/#{token}", %{
          "user" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(conn) == ~p"/users/log_in"
      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Password changed successfully"
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "does not reset password on invalid data", %{conn: conn, token: token} do
      conn =
        put(conn, ~p"/users/reset_password/#{token}", %{
          "user" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "Reset Password"
      assert response =~ "should be at least 12 character(s)"
      assert response =~ "does not match password"
    end
  end
end
