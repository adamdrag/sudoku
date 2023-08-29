defmodule SudokuWeb.UserAuth do
  use SudokuWeb, :verified_routes
  import Plug.Conn
  import Phoenix.Controller

  @rand_size 32

  def new_game(conn, board, level) do
    token = :crypto.strong_rand_bytes(@rand_size)

    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> put_session(:board_number, board)
    |> put_session(:level, level)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
    |> redirect(to: ~p"/game?level=#{level}&board=#{board}")
  end

  def on_mount(:ensure_authenticated, params, session, socket) do
    params_board = params["board"] || -1
    params_level = params["level"] || -1
    session_board = session["board_number"] || -2
    session_level = session["level"] || -2

    if params_board == session_board and params_level == session_level do
      {:cont, socket}
    else
      socket = socket |> Phoenix.LiveView.redirect(to: ~p"/")
      {:halt, socket}
    end
  end
end
