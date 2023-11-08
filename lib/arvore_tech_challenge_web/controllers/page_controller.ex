defmodule ArvoreTechChallengeWeb.PageController do
  use ArvoreTechChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
