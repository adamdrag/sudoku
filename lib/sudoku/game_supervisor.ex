defmodule Sudoku.GameSupervisor do
  @moduledoc """
  A supervisor that starts `GameServer` processes dynamically.
  """
  use DynamicSupervisor
  alias Sudoku.GameServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a `GameServer` process and supervises it.
  """
  def start_game(game_name, level) do
    child_spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [game_name, level]},
      restart: :transient
      # :transient - only restart processes that crashed, don't restart time out processes
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Terminates the `GameServer` process normally. It won't be restarted.
  """
  def stop_game(game_name) do
    :ets.delete(:games_table, game_name)

    child_pid = GameServer.game_pid(game_name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
