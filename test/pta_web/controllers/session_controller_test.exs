defmodule PtaWeb.SessionControllerTest do
  use PtaWeb.ConnCase
  use Pta.Support.JwtTokenHelper

  import Pta.Support.FixtureHelper

  @valid_user %{
    email: "some@email.com",
    lastname: "some lastname",
    name: "some name",
    password: "123456"
  }
  @invalid_user %{email: "wrong@email.com", password: "wrong"}

  describe "unauthorized access" do
    test "requires user on delete", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert json_response(conn, :unauthorized)
      assert conn.halted
    end
  end

  describe "create session" do
    test "assigns current user when credentials are valid", %{conn: conn} do
      {:ok, _, _} = fixture(:user, @valid_user)
      conn = post(conn, Routes.session_path(conn, :create), session: @valid_user)

      assert %{"token" => token} = json_response(conn, :created)["data"]
      assert {:ok, claims} = Pta.Guardian.decode_and_verify(token)
      assert claims["iss"] == "pta"
    end

    test "renders errors when credentials are invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_user)

      assert %{"error" => error, "message" => message} =
               json_response(conn, :unauthorized)["data"]

      assert error == "unauthorized"
      assert message =~ ~r/Invalid/i
    end
  end

  describe "delete" do
    @tag login_as: "test@user.com"
    test "clear session", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert response(conn, :no_content)
    end
  end
end
