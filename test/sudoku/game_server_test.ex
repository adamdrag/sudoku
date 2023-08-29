defmodule Sudoku.GameServerTest do
  use ExUnit.Case, async: true
  alias Sudoku.{GameServer, Game}

  test "spawning a game server process" do
    assert {:ok, _pid} = GameServer.start_link("123456", 1)
  end

  test "a game process is registered under a unique name" do
    assert {:ok, _pid} = GameServer.start_link("123456", 1)

    assert {:error, _reason} = GameServer.start_link("123456", 1)
  end

  test "getting a summary" do
    game_name = "123456"
    {:ok, _pid} = GameServer.start_link(game_name, 1)

    summary = GameServer.summary(game_name)

    assert %{
             board: _board,
             not_used_numbers: _not_used_numbers,
             status: %Sudoku.Status{level: 1, mistakes: 0, loss: false, win: false}
           } = summary
  end

  test "marking square" do
    game_name = "123456"
    {:ok, _pid} = GameServer.start_link(game_name, 0)

    summary = GameServer.place_number(game_name, 0, 4)
    [square_id_0 | _rest] = summary.board

    assert %Sudoku.Square{square_id: 0, value: 4, number: 4} = square_id_0
    assert %Sudoku.Status{mistakes: 0} = summary.status
  end

  test "stores initial state in ETS when started" do
    game_name = "123456"
    {:ok, _pid} = GameServer.start_link(game_name, 0)

    assert [{^game_name, game}] = :ets.lookup(:games_table, game_name)
    assert %Sudoku.Game{} = game
  end

  test "gets its initial state from ETS if previously stored" do
    game_name = "123456"

    game = Game.new(0)
    game = Game.place_number(game, 0, 4)

    :ets.insert(:games_table, {game_name, game})
    {:ok, _pid} = GameServer.start_link(game_name, 0)

    summary = GameServer.summary(game_name)

    [game_square_id_0 | _rest] = game.board
    [summary_square_id_0 | _rest] = summary.board

    assert game_square_id_0 == summary_square_id_0
  end

  describe "game_pid" do
    test "returns a PID if it has been registered" do
      game_name = "123456"
      {:ok, pid} = GameServer.start_link(game_name, 0)

      assert ^pid = GameServer.game_pid(game_name)
    end

    test "returns nil if the game does not exist" do
      refute GameServer.game_pid("nonexistent-game")
    end
  end
end
