defmodule PtaWeb.UserControllerTest do
  use PtaWeb.ConnCase
  use Pta.Support.JwtTokenHelper

  alias Pta.Accounts
  alias Pta.Accounts.User

  import Pta.Support.FixtureHelper

  @create_attrs %{
    email: "some@email.com",
    lastname: "some lastname",
    name: "some name",
    password: "123456"
  }
  @update_attrs %{
    email: "new@email.com",
    lastname: "some updated lastname",
    name: "some updated name"
  }
  @invalid_attrs %{email: "wrong@email", lastname: nil, name: nil, password: "123"}

  describe "unauthorized access" do
    test "requires authentication on all actions", %{conn: conn} do
      Enum.each(
        [
          get(conn, Routes.user_path(conn, :index)),
          get(conn, Routes.user_path(conn, :new)),
          post(conn, Routes.user_path(conn, :create, %{})),
          get(conn, Routes.user_path(conn, :show, "123")),
          get(conn, Routes.user_path(conn, :edit, "123")),
          put(conn, Routes.user_path(conn, :update, "123", %{})),
          delete(conn, Routes.user_path(conn, :delete, "123"))
        ],
        fn conn ->
          assert json_response(conn, :unauthorized)
          assert conn.halted
        end
      )
    end
  end

  describe "index" do
    @tag login_as: "test@user.com"
    test "lists all users", %{conn: conn, account: account} do
      conn = get(conn, Routes.user_path(conn, :index))
      users = Accounts.list_users(account, %{})

      assert json_response(conn, :ok)["data"] == Enum.map(users, &to_json/1)
    end
  end

  describe "create user" do
    @tag login_as: "test@user.com"
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{"id" => id} = json_response(conn, :created)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some@email.com",
               "lastname" => "some lastname",
               "lock_version" => 2,
               "name" => "some name"
             } = json_response(conn, :ok)["data"]
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)

      assert json_response(conn, :unprocessable_entity)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag login_as: "test@user.com"
    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, :ok)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "new@email.com",
               "lastname" => "some updated lastname",
               "lock_version" => 3,
               "name" => "some updated name"
             } = json_response(conn, :ok)["data"]
    end

    @tag login_as: "test@user.com"
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)

      assert json_response(conn, :unprocessable_entity)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    @tag login_as: "test@user.com"
    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))

      assert response(conn, :no_content)

      assert_error_sent :not_found, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(%{account: account}) do
    {:ok, user, _} = fixture(:user, @create_attrs, account)

    {:ok, user: user}
  end

  defp to_json(user) do
    %{
      "id" => user.id,
      "name" => user.name,
      "lastname" => user.lastname,
      "email" => user.email,
      "lock_version" => user.lock_version
    }
  end
end
