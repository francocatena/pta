defmodule PtaWeb.PasswordControllerTest do
  use PtaWeb.ConnCase

  import Pta.Support.FixtureHelper

  alias Pta.Accounts.User
  alias Pta.Repo

  describe "create password" do
    alias Pta.Notifications.Email
    use Bamboo.Test

    test "sends instructions when email exist", %{conn: conn} do
      {:ok, user, _} = fixture(:user)
      conn = post(conn, Routes.password_path(conn, :create), user: %{email: user.email})

      assert %{"message" => message} = json_response(conn, :created)["data"]
      assert message =~ ~r/Password reset instructions sent/

      user = Repo.get(User, user.id)

      assert_delivered_email(Email.password_reset(user))
    end

    test "renders errors when email does not exist", %{conn: conn} do
      conn = post(conn, Routes.password_path(conn, :create), user: %{email: "wrong"})

      assert %{"message" => message} = json_response(conn, :not_found)["data"]
      assert message =~ ~r/Email not found/
    end
  end

  describe "update password" do
    @valid_attrs %{password: "newpass", password_confirmation: "newpass"}
    @invalid_attrs %{password: "newpass", password_confirmation: "wrong"}

    test "redirects when data is valid", %{conn: conn} do
      user = user_with_password_reset_token()
      url = Routes.password_path(conn, :update, user.password_reset_token)
      conn = put(conn, url, user: @valid_attrs)

      assert %{"message" => message} = json_response(conn, :ok)["data"]
      assert message =~ ~r/Password updated successfully/

      user = Repo.get(User, user.id)

      assert Argon2.verify_pass(@valid_attrs.password, user.password_hash)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_with_password_reset_token()
      url = Routes.password_path(conn, :update, user.password_reset_token)
      conn = put(conn, url, user: @invalid_attrs)

      assert %{"errors" => errors} = json_response(conn, :unprocessable_entity)
      assert %{"password_confirmation" => ["does not match confirmation"]} == errors

      user = Repo.get(User, user.id)

      refute Argon2.verify_pass(@invalid_attrs.password, user.password_hash)
    end

    test "redirects when invalid token", %{conn: conn} do
      url = Routes.password_path(conn, :update, "invalid-token")
      conn = put(conn, url, user: @valid_attrs)

      assert %{"message" => message} = json_response(conn, :not_found)["data"]
      assert message =~ ~r/Token invalid or expired/
    end
  end

  defp user_with_password_reset_token do
    {:ok, user, _} = fixture(:user)

    user
    |> User.password_reset_token_changeset()
    |> Repo.update!()
  end
end
