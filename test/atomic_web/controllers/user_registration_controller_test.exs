defmodule AtomicWeb.UserRegistrationControllerTest do
  use AtomicWeb.ConnCase, async: true

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/users/register")
      response = html_response(conn, 200)
      assert response =~ "<span>Register</span>"
      assert response =~ "Login</a>"
      assert response =~ "Register"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(insert(:user)) |> get(~p"/users/register")
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account but doesn't log the user in", %{conn: conn} do
      user_attrs = %{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        role: "student",
        password: "password1234"
      }

      conn =
        post(conn, ~p"/users/register", %{
          "user" => user_attrs
        })

      assert is_nil(get_session(conn, :user_token))
    end
  end
end
