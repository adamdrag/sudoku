defmodule SudokuWeb.GameSessionController do
  use SudokuWeb, :controller
  alias SudokuWeb.UserAuth

  def create(conn, %{"board" => board, "level" => level}) do
    conn
    |> put_flash(:info, "Welcome!")
    |> UserAuth.new_game(board, level)
  end
end
