defmodule PtaWeb.SessionView do
  use PtaWeb, :view

  alias PtaWeb.SessionView

  def render("show.json", %{session: %{error: _error} = session}) do
    %{data: session}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    user = session.session.user
    account = session.session.account

    %{
      token: session.token,
      account: %{
        id: account.id,
        name: account.name
      },
      user: %{
        id: user.id,
        name: user.name,
        lastname: user.lastname,
        email: user.email
      }
    }
  end
end
