defmodule PtaWeb.UserView do
  use PtaWeb, :view

  alias PtaWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      lastname: user.lastname,
      email: user.email,
      lock_version: user.lock_version
    }
  end
end
