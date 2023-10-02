defmodule Sudoku.Templates do
  alias Sudoku.TemplatesCache

  def get_template(level) when is_binary(level) do
    level = String.to_integer(level)
    board_number = Enum.random(1..count_templete_per_level(level))
    template = TemplatesCache.get_templates()[{level, board_number}]
    build_game_board(template, 0, [])
  end

  def get_template(level) do
    board_number = Enum.random(1..count_templete_per_level(level))
    template = TemplatesCache.get_templates()[{level, board_number}]
    build_game_board(template, 0, [])
  end

  defp count_templete_per_level(level) do
    TemplatesCache.get_templates()
    |> Map.keys()
    |> Enum.filter(fn {d, _l} -> d == level end)
    |> length()
  end

  # That data could be fetched from database or external API
  def read_templates() do
    "../../data/sudoku_templates.csv"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn game ->
      [level_and_gameid | game_numbers] = game
      [level, gameid] = String.split(level_and_gameid, " ")
      {{String.to_integer(level), String.to_integer(gameid)}, game_numbers}
    end)
    |> Map.new()
  end

  def build_game_board(template, square_id, game_board_numbers) when template != [] do
    [head | tail_template] = template
    [starting_number, solved_number] = String.split(head, " ")
    starting_number = if starting_number == "0", do: nil, else: String.to_integer(starting_number)

    game_board_numbers = [
      {square_id, starting_number, String.to_integer(solved_number)} | game_board_numbers
    ]

    build_game_board(tail_template, square_id + 1, game_board_numbers)
  end

  def build_game_board(_template, _square_id, game_board_numbers) do
    Enum.reverse(game_board_numbers)
  end

  @doc """
  Parse template
  ## Examples
      iex> parse_template(
        "009008600000040100002000970006000200008500000250003001070000900001000700000030560",
        "319758642657249183842316975196487235378512496254693781573864921861925734429137568"
      )
  """
  def parse_template(starting_numbers_string, solved_numbers_string) do
    starting_numbers_list = String.codepoints(starting_numbers_string)
    solved_numbers_list = String.codepoints(solved_numbers_string)

    Enum.zip([starting_numbers_list, solved_numbers_list])
    |> Enum.reduce("", fn {starting_num, solved_num}, acc ->
      acc <> "#{starting_num} #{solved_num},"
    end)
  end

  def validate_templates() do
    "../../data/sudoku_templates.csv"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn game ->
      [level_and_gameid | game_numbers] = game
      [level, gameid] = String.split(level_and_gameid, " ")

      checked_template =
        Enum.reduce(
          game_numbers,
          %{
            "1" => 0,
            "2" => 0,
            "3" => 0,
            "4" => 0,
            "5" => 0,
            "6" => 0,
            "7" => 0,
            "8" => 0,
            "9" => 0
          },
          fn square, acc ->
            [starting_number, solved_number] = String.split(square, " ")

            if starting_number != "0" and starting_number != solved_number do
              IO.inspect("Invalid starting number: #{starting_number} - {#{level}, #{gameid}}")
            end

            case solved_number do
              "1" -> Map.put(acc, "1", acc["1"] + 1)
              "2" -> Map.put(acc, "2", acc["2"] + 1)
              "3" -> Map.put(acc, "3", acc["3"] + 1)
              "4" -> Map.put(acc, "4", acc["4"] + 1)
              "5" -> Map.put(acc, "5", acc["5"] + 1)
              "6" -> Map.put(acc, "6", acc["6"] + 1)
              "7" -> Map.put(acc, "7", acc["7"] + 1)
              "8" -> Map.put(acc, "8", acc["8"] + 1)
              "9" -> Map.put(acc, "9", acc["9"] + 1)
              _ -> acc
            end
          end
        )

      is_valid? = if checked_template == valid_board(), do: :valid, else: :invalid
      {{String.to_integer(level), String.to_integer(gameid)}, is_valid?}
    end)
    |> Map.new()
  end

  defp valid_board() do
    %{
      "1" => 9,
      "2" => 9,
      "3" => 9,
      "4" => 9,
      "5" => 9,
      "6" => 9,
      "7" => 9,
      "8" => 9,
      "9" => 9
    }
  end
end
