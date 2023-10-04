defmodule Sudoku.TemplateCacheTest do
  use ExUnit.Case, async: true
  alias Sudoku.TemplatesCache

  describe "creating a square" do
    test "new/3" do
      templates = TemplatesCache.get_templates()

      assert %{{0, 0} => _game_board} = templates
    end
  end
end
