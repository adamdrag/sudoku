defmodule Sudoku.Game do
  defstruct board: [],
            not_used_numbers: %{},
            status: %{}

  alias Sudoku.{Game, Square, Status, Templates, Helpers}

  @max_mistakes_number 3

  def new(level) do
    template = Templates.get_template(level)
    # IO.inspect(template)

    board =
      Enum.map(template, fn {square_id, value, number} -> Square.new(square_id, value, number) end)

    not_used_numbers =
      Enum.reduce(template, Helpers.not_used_numbers(), fn {_square_id, value, number}, acc ->
        case value do
          nil -> acc
          _ -> Map.put(acc, number, Map.get(acc, number) - 1)
        end
      end)

    %Game{board: board, not_used_numbers: not_used_numbers, status: Status.new(level)}
  end

  def place_number(game, square_id, value) do
    IO.inspect(game)

    game
    |> update_board_with_mark(square_id, value)
    |> update_not_used_numbers(value, :-)
    |> check_if_assign_mistake(square_id)
    |> check_if_assign_loss()
    |> check_if_assign_win()
  end

  def remove_number(game, square_id, value) do
    game
    |> update_board_with_mark(square_id, nil)
    |> update_not_used_numbers(value, :+)
  end

  defp update_board_with_mark(game, square_id, value) do
    new_squares = game.board |> Enum.map(&mark_square_having_square_id(&1, square_id, value))
    %{game | board: new_squares}
  end

  defp update_not_used_numbers(game, value, operator) do
    updated_number = apply(Kernel, operator, [Map.get(game.not_used_numbers, value), 1])
    new_not_used_numbers = Map.put(game.not_used_numbers, value, updated_number)
    %{game | not_used_numbers: new_not_used_numbers}
  end

  defp check_if_assign_mistake(%{board: board, status: status} = game, square_id) do
    square_by_id = Enum.find(board, fn square -> square.square_id == square_id end)

    case square_by_id.number == square_by_id.value do
      true -> game
      false -> %{game | status: Map.put(status, :mistakes, status.mistakes + 1)}
    end
  end

  defp check_if_assign_loss(game) when game.status.mistakes == @max_mistakes_number,
    do: %{game | status: Map.put(game.status, :loss, true)}

  defp check_if_assign_loss(game), do: game

  defp check_if_assign_win(game) do
    case Enum.filter(game.board, fn square -> square.number != square.value end) do
      [] -> %{game | status: Map.put(game.status, :win, true)}
      _ -> game
    end
  end

  defp mark_square_having_square_id(square, square_id, value) do
    case square.square_id == square_id do
      true -> %Square{square | value: value}
      false -> square
    end
  end
end
