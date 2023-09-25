defmodule AtomicWeb.UserSettingsControllerTest do
  use AtomicWeb.ConnCase, async: true

  alias Atomic.Accounts
  import Atomic.AccountsFixtures

  setup :register_and_log_in_user

  describe "GET /users/change_password" do
    test "renders change password page", %{conn: conn} do
      conn = get(conn, Routes.user_change_password_path(conn, :edit))
      response = html_response(conn, 200)
      assert response =~ "<span>Change Password</span>"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      conn = get(conn, Routes.user_change_password_path(conn, :edit))
      assert redirected_to(conn) == Routes.user_session_path(conn, :new)
    end
  end

  describe "PUT /users/change_password" do
    test "updates the user password and resets tokens", %{conn: conn, user: user} do
      new_password_conn =
        put(conn, Routes.user_change_password_path(conn, :update), %{
          "action" => "update_password",
          "user" => %{
            "current_password" => valid_user_password(),
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(new_password_conn) == Routes.user_change_password_path(conn, :edit)
      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)
      assert get_flash(new_password_conn, :info) =~ "Password updated successfully"
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "does not update password on invalid data", %{conn: conn} do
      old_password_conn =
        put(conn, Routes.user_change_password_path(conn, :update), %{
          "action" => "update_password",
          "user" => %{
            "current_password" => "invalid",
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(old_password_conn, 200)
      assert response =~ "<span>Change Password</span>"
      assert response =~ "should be at least 12 character(s)"
      assert response =~ "does not match password"
      assert response =~ "is not valid"

      assert get_session(old_password_conn, :user_token) == get_session(conn, :user_token)
    end
  end
end
