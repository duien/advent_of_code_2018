defmodule AdventOfCodeTest do
  use ExUnit.Case

  AdventOfCode.days
  |> Enum.map(fn module ->
    doctest module
  end)
end
