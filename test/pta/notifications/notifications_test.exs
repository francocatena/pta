defmodule Pta.NotificationsTest do
  use ExUnit.Case
  use Bamboo.Test

  alias Pta.Accounts.User
  alias Pta.Notifications
  alias Pta.Notifications.Email

  test "password reset email" do
    user = %User{name: "John", email: "some@email.com", password_reset_token: "test-token"}

    Notifications.send_password_reset(user)

    assert_delivered_email(Email.password_reset(user))
  end
end
