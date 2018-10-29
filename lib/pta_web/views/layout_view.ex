defmodule PtaWeb.LayoutView do
  use PtaWeb, :view

  def locale do
    PtaWeb.Gettext
    |> Gettext.get_locale()
    |> String.replace(~r/_\w+/, "")
  end
end
