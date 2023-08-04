defmodule Sudoku.Templates do
  alias Sudoku.TemplatesCache

  def get_template(level) when is_binary(level) do
    level = String.to_integer(level)
    board_number = Enum.random(1..templete_count_by_level(level))
    build_tamplate(level, board_number)
  end

  def get_template(level) do
    board_number = Enum.random(1..templete_count_by_level(level))
    build_tamplate(level, board_number)
  end

  defp templete_count_by_level(level) do
    TemplatesCache.get_templates()
    |> Map.keys()
    |> Enum.filter(fn {d, _l} -> d == level end)
    |> length()
  end

  defp build_tamplate(level, board_number) do
    template = TemplatesCache.get_templates()[{level, board_number}]

    Enum.map(ids(), fn id ->
      id = String.to_integer(id)
      starting_number = Enum.at(template.starting_numbers, id) |> String.to_integer()
      solved_number = Enum.at(template.solved_numbers, id) |> String.to_integer()
      starting_number = if starting_number == 0, do: nil, else: starting_number

      {id, starting_number, solved_number}
    end)
  end

  defp ids do
    ~w(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80)
  end

  # That data could be fetched from database or external API
  def read_templates do
    %{
      {1, 1} => %{
        starting_numbers:
          ~w(0 0 0 0 0 0 6 0 0 8 0 5 2 0 3 0 9 0 0 1 3 6 0 0 2 0 4 0 0 0 0 4 0 2 5 6 0 0 0 1 0 0 3 0 4 0 0 5 7 0 6 8 9 0 5 9 0 1 0 2 0 0 4 0 0 7 0 8 0 9 1 0 1 0 2 4 7 0 0 3 8),
        solved_numbers:
          ~w(4 2 7 9 1 5 6 8 3 8 6 5 2 4 3 7 9 1 9 1 3 6 8 7 2 5 4 8 7 1 3 4 9 2 5 6 6 2 9 1 5 8 3 7 4 3 4 5 7 2 6 8 9 1 5 9 8 1 3 2 7 6 4 4 3 7 5 8 6 9 1 2 1 6 2 4 7 9 5 3 8)
      },
      {1, 2} => %{
        starting_numbers:
          ~w(0 0 9 5 3 8 1 6 2 0 0 2 0 6 4 0 0 0 0 0 5 0 0 9 0 3 0 0 0 3 0 5 4 0 0 7 0 2 7 6 0 0 0 1 5 0 0 0 1 0 0 3 4 0 3 0 0 7 0 0 0 9 1 8 0 1 3 0 0 0 0 0 9 0 6 8 5 0 4 7 0),
        solved_numbers:
          ~w(4 7 9 5 3 8 1 6 2 1 3 2 7 6 4 5 9 8 6 8 5 2 1 9 7 3 4 9 1 3 2 5 4 6 8 7 4 2 7 6 8 3 9 1 5 5 6 8 1 9 7 3 4 2 3 4 5 7 2 6 8 9 1 8 7 1 3 4 9 2 5 6 9 2 6 8 5 1 4 7 3)
      },
      {1, 3} => %{
        starting_numbers:
          ~w(0 5 8 4 0 2 0 0 7 0 3 0 0 0 0 0 0 0 0 2 0 9 0 5 6 8 0 2 9 0 5 0 0 0 0 3 0 5 4 0 6 2 8 1 0 0 7 0 0 0 0 2 5 0 1 0 9 8 6 5 0 7 0 0 0 3 4 9 0 0 0 6 0 6 4 1 3 0 0 0 0),
        solved_numbers:
          ~w(6 5 8 4 3 2 9 1 7 9 3 1 6 7 8 2 4 5 4 2 7 9 1 5 6 8 3 2 9 6 5 8 1 7 4 3 3 5 4 7 6 2 8 1 9 8 7 1 3 4 9 2 5 6 1 2 9 8 6 5 3 7 4 5 8 3 4 9 7 1 2 6 7 6 4 1 3 2 5 9 8)
      },
      {2, 1} => %{
        starting_numbers:
          ~w(0 1 0 7 0 0 0 0 0 0 0 0 0 0 0 2 5 4 4 3 0 0 0 0 9 0 0 1 7 0 0 0 0 0 0 3 0 4 0 0 9 0 0 0 6 2 0 6 0 0 3 0 8 0 0 0 1 0 0 0 0 9 0 4 7 0 5 0 8 0 6 0 0 6 0 1 2 0 3 0 4),
        solved_numbers:
          ~w(5 1 9 7 2 4 3 8 6 6 8 7 9 1 3 2 5 4 4 3 2 6 5 8 9 1 7 1 7 8 6 5 2 9 4 3 3 4 5 8 9 1 7 2 6 2 9 6 7 4 3 5 8 1 2 3 1 4 6 7 8 9 5 4 7 9 5 3 8 1 6 2 8 6 5 1 2 9 3 7 4)
      },
      {2, 2} => %{
        starting_numbers:
          ~w(0 0 0 0 0 2 5 0 6 4 0 0 0 0 0 9 0 0 2 0 0 0 1 8 0 3 0 0 6 9 0 5 0 8 0 0 0 0 0 0 0 0 1 5 7 3 0 0 0 2 1 6 0 9 0 0 0 9 0 0 0 0 0 0 3 0 6 0 2 0 0 0 9 6 0 0 5 0 7 0 2),
        solved_numbers:
          ~w(3 8 7 4 9 2 5 1 6 4 1 5 7 6 3 9 2 8 2 9 6 5 1 8 4 3 7 1 6 9 7 5 4 8 2 3 2 8 4 3 9 6 1 5 7 3 7 5 8 2 1 6 4 9 2 7 5 9 4 8 6 3 1 8 3 1 6 7 2 5 4 9 9 6 4 1 5 3 7 8 2)
      },
      {3, 1} => %{
        starting_numbers:
          ~w(0 0 4 0 0 1 8 0 0 8 6 0 0 0 0 0 0 9 0 3 0 0 9 0 0 6 0 5 0 0 0 2 7 0 0 0 2 0 6 0 0 1 0 4 3 0 0 1 0 0 0 0 0 6 0 5 0 0 0 9 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 4 0 0 0 1 5),
        solved_numbers:
          ~w(9 7 4 2 6 1 8 3 5 8 6 5 3 7 4 1 2 9 1 3 2 5 9 8 7 6 4 5 4 3 6 2 7 1 9 8 2 9 6 5 8 1 7 4 3 8 7 1 3 4 9 2 5 6 4 5 2 3 1 9 7 8 6 9 1 7 6 5 8 4 3 2 6 8 3 4 2 7 9 1 5)
      },
      {4, 1} => %{
        starting_numbers:
          ~w(5 0 0 0 0 9 0 0 0 0 7 0 0 0 1 5 0 9 0 8 4 2 0 0 0 0 0 0 0 0 0 1 0 7 5 3 0 0 0 0 9 6 0 0 0 0 0 0 0 4 0 1 0 0 0 7 4 0 0 0 9 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 2 0 3 0 0),
        solved_numbers:
          ~w(5 3 1 6 4 9 8 2 7 6 7 2 8 3 1 5 4 9 9 8 4 2 5 7 6 1 3 4 9 6 2 1 8 7 5 3 1 5 7 3 9 6 2 8 4 8 3 2 7 4 5 1 9 6 3 7 4 1 8 5 9 6 2 9 2 8 7 6 3 4 1 5 5 6 1 4 2 9 3 7 8)
      }
    }
  end
end
