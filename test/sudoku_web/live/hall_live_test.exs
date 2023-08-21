defmodule SudokuWeb.HallLiveTest do
  use SudokuWeb.ConnCase
  import Phoenix.LiveViewTest

  test "renders", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert render(view) =~ "Sudoku"
    assert view |> element("a", "Easy")
  end
end
