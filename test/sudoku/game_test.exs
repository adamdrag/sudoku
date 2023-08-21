defmodule Sudoku.GameTest do
  use ExUnit.Case, async: true
  alias Sudoku.Game

  describe "creating a game" do
    test "new/1" do
      game = Game.new(0)

      assert %Sudoku.Game{
               board: _board,
               not_used_numbers: _not_used_numbers,
               status: %Sudoku.Status{level: 0, mistakes: 0, loss: false, win: false}
             } = game
    end
  end

  describe "playing a game" do
    test "place_number/3 correct number" do
      game = Game.new(0)
      [square_id_0 | _rest] = game.board

      assert %Sudoku.Square{square_id: 0, value: nil, number: 4} = square_id_0

      game = Game.place_number(game, 0, 4)
      [square_id_0 | _rest] = game.board

      assert %Sudoku.Square{square_id: 0, value: 4, number: 4} = square_id_0
      assert %Sudoku.Status{mistakes: 0} = game.status
    end

    test "place_number/3 - incorrect number" do
      game = Game.new(0)
      [square_id_0 | _rest] = game.board

      assert %Sudoku.Square{square_id: 0, value: nil, number: 4} = square_id_0

      game = Game.place_number(game, 0, 1)
      [square_id_0 | _rest] = game.board

      assert %Sudoku.Square{square_id: 0, value: 1, number: 4} = square_id_0
      assert %Sudoku.Status{mistakes: 1} = game.status
    end

    test "place_number/3 - loss game" do
      game = Game.new(0)
      assert %Sudoku.Status{mistakes: 0, loss: false} = game.status

      game =
        game
        |> Game.place_number(0, 1)
        |> Game.remove_number(0, 1)
        |> Game.place_number(0, 2)
        |> Game.remove_number(0, 2)
        |> Game.place_number(0, 3)
        |> Game.remove_number(0, 3)

      assert %Sudoku.Status{mistakes: 3, loss: true} = game.status
    end

    test "remove_number/3" do
      game = Game.new(0)
      game = Game.place_number(game, 0, 4)
      [square_id_0 | _rest] = game.board

      assert %Sudoku.Square{square_id: 0, value: 4, number: 4} = square_id_0

      game = Game.remove_number(game, 0, 4)
      [square_id_0 | _rest] = game.board

      assert %Sudoku.Square{square_id: 0, value: nil, number: 4} = square_id_0
    end
  end
end
