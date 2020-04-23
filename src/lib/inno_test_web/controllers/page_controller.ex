defmodule InnoTestWeb.PageController do
  use InnoTestWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
