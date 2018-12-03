defmodule AdventOfCode.InventoryManagementSystem do
  @input_file Application.app_dir(:advent_of_code, "priv/day_2.txt")

  def part1, do: {"What is the checksum?", checksum()}
  def part2, do: {"What letters are common between the two correct box IDs?", prototype_boxes()}

  @doc """
  Examples

      iex> AdventOfCode.InventoryManagementSystem.checksum(~w(abcdef bababc abbcde abcccd aabcdd abcdee ababab))
      12
  """
  def checksum(box_ids \\ input()) do
    exactly_2 = box_ids
    |> Enum.count(&has_appearances(&1, 2))

    exactly_3 = box_ids
    |> Enum.count(&has_appearances(&1, 3))
    exactly_2 * exactly_3
  end

  def has_appearances(string, count) do
    String.to_charlist(string)
    |> Enum.group_by(&(&1))
    |> Enum.any?(fn {_letter, group} -> Enum.count(group) == count end)
  end

  # Take the input file and turn it into a list of strings
  def input do
    @input_file
    |> File.stream!
    |> Enum.map(&String.trim(&1))
  end

  @doc """
  Examples

      iex> AdventOfCode.InventoryManagementSystem.prototype_boxes(~w"abcde fghij klmno pqrst fguij axcye wvxyz")
      "fgij"
  """
  def prototype_boxes(box_ids \\ input()) do
    boxes = for left <- box_ids,
                right <- box_ids
            do
              {to_charlist(left), to_charlist(right)}
            end
    |> Enum.find(fn {left, right} ->
      Enum.zip(left, right)
      |> Enum.count(fn {l,r} -> l != r end) == 1
    end)

    with {left, right } <- boxes do
      Enum.zip(left, right)
      |> Enum.filter(fn {l,r} -> l == r end)
      |> Enum.map(fn {l,_} -> l end)
      |> to_string
    end
  end
end
