defmodule DukkadeeWeb.PageController do
  use DukkadeeWeb, :controller

  def home(conn, _params) do
    # Render the template
    render(conn, :home)
  end
end
