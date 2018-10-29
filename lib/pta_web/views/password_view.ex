defmodule PtaWeb.PasswordView do
  use PtaWeb, :view

  def render("show.json", %{response: response}) do
    %{data: response}
  end
end
