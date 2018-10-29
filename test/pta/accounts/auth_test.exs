defmodule Pta.Accounts.AuthTest do
  use Pta.DataCase

  describe "auth" do
    alias Pta.Accounts.{Auth, Session}

    @valid_attrs %{
      email: "some@email.com",
      lastname: "some lastname",
      name: "some name",
      password: "123456"
    }

    test "authenticate_by_email_and_password/2 returns :ok with valid credentials" do
      {:ok, user, account} = fixture(:user, @valid_attrs)
      user = %{user | account: account}
      email = @valid_attrs.email
      password = @valid_attrs.password
      {:ok, session} = Auth.authenticate_by_email_and_password(email, password)

      assert session == %Session{user: user, account: account}
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid credentials" do
      email = @valid_attrs.email
      password = "wrong"

      # Create user just to be sure
      fixture(:user, @valid_attrs)

      assert {:error, :unauthorized} == Auth.authenticate_by_email_and_password(email, password)
    end

    test "authenticate_by_email_and_password/2 returns :error with invalid email" do
      email = "invalid@email.com"
      password = @valid_attrs.password

      assert {:error, :unauthorized} == Auth.authenticate_by_email_and_password(email, password)
    end
  end
end
