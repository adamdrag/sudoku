defmodule Sudoku.GameServer do
  use GenServer
  require Logger
  alias Sudoku.Game

  @timeout :timer.hours(2)

  # Client (Public) Interface

  @doc """
  Spawns a new game server process registered under the given `game_name`.
  """

  def start_link(game_name, level) do
    GenServer.start_link(
      __MODULE__,
      {game_name, level},
      name: via_tuple(game_name)
    )
  end

  def summary(game_name) do
    GenServer.call(via_tuple(game_name), :summary)
  end

  def place_number(game_name, square_id, value) do
    GenServer.call(via_tuple(game_name), {:place_number, square_id, value})
  end

  def remove_number(game_name, square_id, value) do
    GenServer.call(via_tuple(game_name), {:remove_number, square_id, value})
  end

  @doc """
  Returns a tuple used to register and lookup a game server process by name.
  """
  def via_tuple(game_name) do
    {:via, Registry, {Sudoku.GameRegistry, game_name}}
  end

  @doc """
  Returns the `pid` of the game server process registered under the
  given `game_name`, or `nil` if no process is registered.
  """
  def game_pid(game_name) do
    game_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  # Server Callbacks
  def init({game_name, level}) do
    game =
      case :ets.lookup(:games_table, game_name) do
        [] ->
          game = Game.new(level)
          :ets.insert(:games_table, {game_name, game})
          game

        [{^game_name, game}] ->
          game
      end

    Logger.info("Spawned game server process named '#{game_name}'.")

    {:ok, game, @timeout}
  end

  def handle_call(:summary, _from, game) do
    {:reply, summarize(game), game, @timeout}
  end

  def handle_call({:place_number, square_id, value}, _from, game) do
    new_game = Sudoku.Game.place_number(game, square_id, value)

    :ets.insert(:games_table, {my_game_name(), new_game})

    {:reply, summarize(new_game), new_game, @timeout}
  end

  def handle_call({:remove_number, square_id, value}, _from, game) do
    new_game = Sudoku.Game.remove_number(game, square_id, value)

    :ets.insert(:games_table, {my_game_name(), new_game})

    {:reply, summarize(new_game), new_game, @timeout}
  end

  # Changing game struct to map. Maybe we don't send some information from struct to client
  def summarize(game) do
    %{
      board: game.board,
      not_used_numbers: game.not_used_numbers,
      status: game.status
    }
  end

  def handle_info(:timeout, game) do
    {:stop, {:shutdown, :timeout}, game}
  end

  def terminate({:shutdown, :timeout}, _game) do
    :ets.delete(:games_table, my_game_name())
    :ok
  end

  def terminate(_reason, _game) do
    :ok
  end

  defp my_game_name do
    Registry.keys(Sudoku.GameRegistry, self()) |> List.first()
  end
end

# --------- Testing This Module --------------
# iex(1)> Sudoku.GameServer.start_link("43535", 1)
#     [info] Spawned game server process named '43535'.
#     {:ok, #PID<0.366.0>}
# iex(2)> summary = Sudoku.GameServer.summary("43535")
#     %{
#       board: [
#         %Sudoku.Square{number: 4, square_id: 0, value: nil},
#         %Sudoku.Square{...},
#         ...
#       ],
#       loss: nil,
#       mistakes: 0,
#       not_used_numbers: %{
#         1 => 4,
#         ...
#       },
#       win: nil
#     }
# iex(3)> Sudoku.GameServer.place_number("43535", 1, 4)
