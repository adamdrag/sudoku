defmodule Sudoku.Square do
  defstruct square_id: nil, value: nil, number: nil
  alias __MODULE__

  def new(square_id, value, number) do
    %Square{square_id: square_id, value: value, number: number}
  end
end
