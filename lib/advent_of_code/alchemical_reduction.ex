defmodule AdventOfCode.AlchemicalReduction do
  @input_file Application.app_dir(:advent_of_code, "priv/day_5.txt")

  @part1 "How many units remain after fully reacting the polymer you scanned?"
  @part2 "What is the length of the shortest polymer you can produce by removing all units of exactly one type and fully reacting the result?"
  def part1, do: {@part1, &polymer_length/0}
  def part2, do: {@part2, &shortest_polymer/0}

  @lower 97..122
  @upper 65..90

  @doc """
  Examples:

      iex> AdventOfCode.AlchemicalReduction.polymer_length("dabAcCaCBAcCcaDA")
      10
  """
  def polymer_length(polymer \\ input()) do
    polymer
    |> react
    |> String.length
  end

  @doc """
  Examples:

      iex> AdventOfCode.AlchemicalReduction.shortest_polymer("dabAcCaCBAcCcaDA")
      4
  """
  def shortest_polymer(polymer \\ input()) do
    {letter, length} = @lower
    |> Enum.map(&List.to_string([&1]))
    |> Enum.map(fn letter ->
      length = polymer
      |> remove_unit(letter)
      |> react
      |> String.length
      |> IO.inspect(label: letter)

      {letter, length}
    end)
    |> Enum.min_by(fn {_,l} -> l end)
    |> IO.inspect

    length
  end

  @polymer_regex Enum.zip(@lower, @upper)
  |> Enum.map(fn {a,b} -> [[a,b], [b,a]] end)
  |> Enum.concat
  |> Enum.join("|")
  |> Regex.compile!

  def react(polymer) do
    if polymer =~ @polymer_regex,
      do: react(Regex.replace(@polymer_regex, polymer, "")),
      else: polymer
  end

  def remove_unit(polymer, unit), do: Regex.replace(~r/#{unit}/i, polymer, "")

  defp input do
    @input_file
    |> File.read!
    |> String.trim
  end
end
