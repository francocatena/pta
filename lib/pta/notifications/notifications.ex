defmodule Pta.Notifications do
  alias Pta.Accounts.User
  alias Pta.Notifications.{Mailer, Email}

  def send_password_reset(%User{} = user) do
    Email.password_reset(user)
    |> Mailer.deliver_later()
  end
end
