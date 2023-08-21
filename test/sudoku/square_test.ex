defmodule Sudoku.SquareTest do
  use ExUnit.Case, async: true
  alias Sudoku.Square

  describe "creating a square" do
    test "new/3" do
      square = Square.new(0, nil, 9)

      assert %Sudoku.Square{square_id: 0, value: nil, number: 9} = square
    end
  end
end
