defmodule AtomicWeb.UserRegistrationControllerTest do
  use AtomicWeb.ConnCase, async: true

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<span>Register</span>"
      assert response =~ "Login</a>"
      assert response =~ "Register"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(insert(:user)) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account but doesn't log the user in", %{conn: conn} do
      organization = insert(:organization)

      user_attrs = %{
        name: Faker.Person.name(),
        email: Faker.Internet.email(),
        role: "student",
        password: "password1234",
        default_organization_id: organization.id
      }

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => user_attrs
        })

      assert is_nil(get_session(conn, :user_token))
    end
  end
end
