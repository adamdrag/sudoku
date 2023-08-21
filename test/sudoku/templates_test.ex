defmodule Sudoku.TemplatesTest do
  use ExUnit.Case, async: true
  alias Sudoku.Templates

  describe "creating a template" do
    test "get_template/1" do
      template = Templates.get_template(0)

      assert [{0, nil, 4} | _rest_squares] = template
    end
  end
end
