defmodule Sudoku.StatusTest do
  use ExUnit.Case, async: true
  alias Sudoku.Status

  describe "creating a status" do
    test "new/1" do
      status = Status.new(2)

      assert %Sudoku.Status{level: 2, mistakes: 0, loss: false, win: false} = status
    end
  end
end
