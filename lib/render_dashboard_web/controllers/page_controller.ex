defmodule RenderDashboardWeb.PageController do
  use RenderDashboardWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
