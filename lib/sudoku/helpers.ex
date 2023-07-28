defmodule Sudoku.Helpers do
  def human_readable_level do
    %{
      1 => "Easy",
      2 => "Medium",
      3 => "Hard",
      4 => "Expert",
      "1" => "Easy",
      "2" => "Medium",
      "3" => "Hard",
      "4" => "Expert"
    }
  end

  def remove_last_value_from_list(list) do
    list
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
  end

  def focus_squares do
    %{
      "0" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 18, 19, 20, 27, 30, 33, 54, 57, 60],
      "1" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 18, 19, 20, 28, 31, 34, 55, 58, 61],
      "2" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 18, 19, 20, 29, 32, 35, 56, 59, 62],
      "3" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 14, 21, 22, 23, 27, 30, 33, 54, 57, 60],
      "4" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 14, 21, 22, 23, 28, 31, 34, 55, 58, 61],
      "5" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 12, 13, 14, 21, 22, 23, 29, 32, 35, 56, 59, 62],
      "6" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 15, 16, 17, 24, 25, 26, 27, 30, 33, 54, 57, 60],
      "7" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 15, 16, 17, 24, 25, 26, 28, 31, 34, 55, 58, 61],
      "8" => [0, 1, 2, 3, 4, 5, 6, 7, 8, 15, 16, 17, 24, 25, 26, 29, 32, 35, 56, 59, 62],
      "9" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 0, 1, 2, 18, 19, 20, 36, 39, 42, 63, 66, 69],
      "10" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 0, 1, 2, 18, 19, 20, 37, 40, 43, 64, 67, 70],
      "11" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 0, 1, 2, 18, 19, 20, 38, 41, 44, 65, 68, 71],
      "12" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 3, 4, 5, 21, 22, 23, 36, 39, 42, 63, 66, 69],
      "13" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 3, 4, 5, 21, 22, 23, 37, 40, 43, 64, 67, 70],
      "14" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 3, 4, 5, 21, 22, 23, 38, 41, 44, 65, 68, 71],
      "15" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 6, 7, 8, 24, 25, 26, 36, 39, 42, 63, 66, 69],
      "16" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 6, 7, 8, 24, 25, 26, 37, 40, 43, 64, 67, 70],
      "17" => [9, 10, 11, 12, 13, 14, 15, 16, 17, 6, 7, 8, 24, 25, 26, 38, 41, 44, 65, 68, 71],
      "18" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 0, 1, 2, 9, 10, 11, 45, 48, 51, 72, 75, 78],
      "19" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 0, 1, 2, 9, 10, 11, 46, 49, 52, 73, 76, 79],
      "20" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 0, 1, 2, 9, 10, 11, 47, 50, 53, 74, 77, 80],
      "21" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 3, 4, 5, 12, 13, 14, 45, 48, 51, 72, 75, 78],
      "22" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 3, 4, 5, 12, 13, 14, 46, 49, 52, 73, 76, 79],
      "23" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 3, 4, 5, 12, 13, 14, 47, 50, 53, 74, 77, 80],
      "24" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 6, 7, 8, 15, 16, 17, 45, 48, 51, 72, 75, 78],
      "25" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 6, 7, 8, 15, 16, 17, 46, 49, 52, 73, 76, 79],
      "26" => [18, 19, 20, 21, 22, 23, 24, 25, 26, 6, 7, 8, 15, 16, 17, 47, 50, 53, 74, 77, 80],
      "27" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 45, 46, 47, 0, 3, 6, 54, 57, 60],
      "28" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 45, 46, 47, 1, 4, 7, 55, 58, 61],
      "29" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 45, 46, 47, 2, 5, 8, 56, 59, 62],
      "30" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 39, 40, 41, 48, 49, 50, 0, 3, 6, 54, 57, 60],
      "31" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 39, 40, 41, 48, 49, 50, 1, 4, 7, 55, 58, 61],
      "32" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 39, 40, 41, 48, 49, 50, 2, 5, 8, 56, 59, 62],
      "33" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 42, 43, 44, 51, 52, 53, 0, 3, 6, 54, 57, 60],
      "34" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 42, 43, 44, 51, 52, 53, 1, 4, 7, 55, 58, 61],
      "35" => [27, 28, 29, 30, 31, 32, 33, 34, 35, 42, 43, 44, 51, 52, 53, 2, 5, 8, 56, 59, 62],
      "36" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 27, 28, 29, 45, 46, 47, 9, 12, 15, 63, 66, 69],
      "37" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 27, 28, 29, 45, 46, 47, 10, 13, 16, 64, 67, 70],
      "38" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 27, 28, 29, 45, 46, 47, 11, 14, 17, 65, 68, 71],
      "39" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 30, 31, 32, 48, 49, 50, 9, 12, 15, 63, 66, 69],
      "40" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 30, 31, 32, 48, 49, 50, 10, 13, 16, 64, 67, 70],
      "41" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 30, 31, 32, 48, 49, 50, 11, 14, 17, 65, 68, 71],
      "42" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 33, 34, 35, 51, 52, 53, 9, 12, 15, 63, 66, 69],
      "43" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 33, 34, 35, 51, 52, 53, 10, 13, 16, 64, 67, 70],
      "44" => [36, 37, 38, 39, 40, 41, 42, 43, 44, 33, 34, 35, 51, 52, 53, 11, 14, 17, 65, 68, 71],
      "45" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 27, 28, 29, 36, 37, 38, 18, 21, 24, 72, 75, 78],
      "46" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 27, 28, 29, 36, 37, 38, 19, 22, 25, 73, 76, 79],
      "47" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 27, 28, 29, 36, 37, 38, 20, 23, 26, 74, 77, 80],
      "48" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 30, 31, 32, 39, 40, 41, 18, 21, 24, 72, 75, 78],
      "49" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 30, 31, 32, 39, 40, 41, 19, 22, 25, 73, 76, 79],
      "50" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 30, 31, 32, 39, 40, 41, 20, 23, 26, 74, 77, 80],
      "51" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 33, 34, 35, 42, 43, 44, 18, 21, 24, 72, 75, 78],
      "52" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 33, 34, 35, 42, 43, 44, 19, 22, 25, 73, 76, 79],
      "53" => [45, 46, 47, 48, 49, 50, 51, 52, 53, 33, 34, 35, 42, 43, 44, 20, 23, 26, 74, 77, 80],
      "54" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 72, 73, 74, 0, 3, 6, 27, 30, 33],
      "55" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 72, 73, 74, 1, 4, 7, 28, 31, 34],
      "56" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 72, 73, 74, 2, 5, 8, 29, 32, 35],
      "57" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 66, 67, 68, 75, 76, 77, 0, 3, 6, 27, 30, 33],
      "58" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 66, 67, 68, 75, 76, 77, 1, 4, 7, 28, 31, 34],
      "59" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 66, 67, 68, 75, 76, 77, 2, 5, 8, 29, 32, 35],
      "60" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 69, 70, 71, 78, 79, 80, 0, 3, 6, 27, 30, 33],
      "61" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 69, 70, 71, 78, 79, 80, 1, 4, 7, 28, 31, 34],
      "62" => [54, 55, 56, 57, 58, 59, 60, 61, 62, 69, 70, 71, 78, 79, 80, 2, 5, 8, 29, 32, 35],
      "63" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 54, 55, 56, 72, 73, 74, 9, 12, 15, 36, 39, 42],
      "64" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 54, 55, 56, 72, 73, 74, 10, 13, 16, 37, 40, 43],
      "65" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 54, 55, 56, 72, 73, 74, 11, 14, 17, 38, 41, 44],
      "66" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 57, 58, 58, 75, 76, 77, 9, 12, 15, 36, 39, 42],
      "67" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 57, 58, 58, 75, 76, 77, 10, 13, 16, 37, 40, 43],
      "68" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 57, 58, 58, 75, 76, 77, 11, 14, 17, 38, 41, 44],
      "69" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 60, 61, 62, 78, 79, 80, 9, 12, 15, 36, 39, 42],
      "70" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 60, 61, 62, 78, 79, 80, 10, 13, 16, 37, 40, 43],
      "71" => [63, 64, 65, 66, 67, 68, 69, 70, 71, 60, 61, 62, 78, 79, 80, 11, 14, 17, 38, 41, 44],
      "72" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 54, 55, 56, 63, 64, 65, 18, 21, 24, 45, 48, 51],
      "73" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 54, 55, 56, 63, 64, 65, 19, 22, 25, 46, 49, 52],
      "74" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 54, 55, 56, 63, 64, 65, 20, 23, 26, 47, 50, 53],
      "75" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 57, 58, 59, 66, 67, 68, 18, 21, 24, 45, 48, 51],
      "76" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 57, 58, 59, 66, 67, 68, 19, 22, 25, 46, 49, 52],
      "77" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 57, 58, 59, 66, 67, 68, 20, 23, 26, 47, 50, 53],
      "78" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 60, 61, 62, 69, 70, 71, 18, 21, 24, 45, 48, 51],
      "79" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 60, 61, 62, 69, 70, 71, 19, 22, 25, 46, 49, 52],
      "80" => [72, 73, 74, 75, 76, 77, 78, 79, 80, 60, 61, 62, 69, 70, 71, 20, 23, 26, 47, 50, 53]
    }
  end
end
