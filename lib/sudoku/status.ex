defmodule Sudoku.Status do
  defstruct level: 1, mistakes: 0, loss: false, win: false
  alias __MODULE__

  def new(level) do
    %Status{level: level}
  end
end
