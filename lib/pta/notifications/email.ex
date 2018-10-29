defmodule Pta.Notifications.Email do
  use Bamboo.Phoenix, view: PtaWeb.EmailView

  import Bamboo.Email
  import PtaWeb.Gettext

  alias Pta.Accounts.User

  def password_reset(%User{} = user) do
    subject = dgettext("emails", "Password reset")

    base_email()
    |> to(user.email)
    |> subject(subject)
    |> render(:password_reset, user: user)
  end

  defp base_email() do
    new_email()
    |> from({gettext("Vintock"), "support@vintock.com"})
    |> put_layout({PtaWeb.LayoutView, :email})
  end
end
