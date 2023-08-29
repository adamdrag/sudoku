defmodule SudokuWeb.Router do
  use SudokuWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SudokuWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SudokuWeb do
    pipe_through :browser

    live "/", HallLive.Index, :index
    post("/game", GameSessionController, :create)

    live_session :ensure_authenticated,
      on_mount: [{SudokuWeb.UserAuth, :ensure_authenticated}] do
      live "/game", GameLive.Index, :index
      live "game/status", GameLive.Index, :status
    end
  end

  if Application.compile_env(:sudoku, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SudokuWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
