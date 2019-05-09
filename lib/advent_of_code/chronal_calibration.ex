defmodule AdventOfCode.ChronalCalibration do
  @input_file Application.app_dir(:advent_of_code, "priv/day_1.txt")

  @part1 "What is the resulting frequency?"
  @part2 "What is the first frequency your device reaches twice?"
  def part1, do: {@part1, fn -> frequency parse_adjustments() end }
  def part2, do: {@part2, fn -> repeated_frequency parse_adjustments() end}

  @doc """
  Given a starting frequency, applies an array of integer adjustments

  ## Examples

      iex> AdventOfCode.ChronalCalibration.frequency([1, -2, 3, 1])
      3

      iex> AdventOfCode.ChronalCalibration.frequency(0, [1,1,1])
      3

      iex> AdventOfCode.ChronalCalibration.frequency(0, [1,1,-2])
      0

      iex> AdventOfCode.ChronalCalibration.frequency([-1,-2,-3])
      -6
  """
  def frequency(starting \\ 0, adjustments) do
    adjustments
    |> Enum.reduce(starting, fn adj, freq -> freq + adj end)
  end


  @doc """
  ## Examples

      iex> AdventOfCode.ChronalCalibration.repeated_frequency([1, -1])
      0

      iex> AdventOfCode.ChronalCalibration.repeated_frequency([3, 3, 4, -2, -4])
      10

      iex> AdventOfCode.ChronalCalibration.repeated_frequency([-6, 3, 8, 5, -6])
      5

      iex> AdventOfCode.ChronalCalibration.repeated_frequency([7, 7, -2, -7, -4])
      14
  """
  def repeated_frequency(starting \\ 0, adjustments) do
    Stream.concat([starting], Stream.cycle(adjustments))
    |> Stream.scan(0, &(&1 + &2))
    # at this point we have a sequence of frequency values and need to find
    # the first repeated one
    |>Enum.reduce_while(MapSet.new(), fn freq, acc ->
      if MapSet.member?(acc, freq) do
        {:halt, freq}
      else
        {:cont, MapSet.put(acc, freq) }
      end
    end)
  end

  # Take the input file and turn it into a stream of integers
  def parse_adjustments do
    @input_file
    |> File.stream!
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.trim_leading(&1, "+"))
    |> Stream.map(fn n -> {n, _} = Integer.parse(n) ; n end)
  end
end
