defmodule AdventOfCode.ChronalCoordinates do
  @input_file Application.app_dir(:advent_of_code, "priv/day_5.txt")

  @part1 "What is the size of the largest area that isn't infinite?"
  # @part2 "What is the length of the shortest polymer you can produce by removing all units of exactly one type and fully reacting the result?"
  def part1, do: {@part1, &largest_area/0}
  # def part2, do: {@part2, &shortest_polymer/0}

  @doc """
  Examples:

      iex> AdventOfCode.ChronalCoordinates.largest_area(\"\"\"
      ...> 1, 1
      ...> 1, 6
      ...> 8, 3
      ...> 3, 4
      ...> 5, 5
      ...> 8, 9
      ...> \"\"\")
      10
  """
  def largest_area(coordinates \\ input()) do
    coordinates = coordinates
    |> process_input
    |> IO.inspect(label: "processed input")

    with {{min_x, _}, {max_x, _}} <- Enum.min_max_by(coordinates, &with( {x, _y} <- &1, do: x)),
      {{_, min_y}, {_, max_y}} <- Enum.min_max_by(coordinates, &with( {_x, y} <- &1, do: y))
    do
      for x <- min_x..max_x,
        y <- min_y..max_y,
        do: {{x, y}, closest_point({x,y}, coordinates)} |> IO.inspect
      IO.inspect {min_x..max_x, min_y..max_y}, label: "extent"
      coordinates
      |>Enum.map(fn {x,y} ->
        if x == min_x || x == max_x || y == min_y || y == max_y do
          {{x,y}, :infinite}
        else
          {{x,y}, :finite}
        end
      end)
      |> IO.inspect
      |> Enum.filter(fn {{_x,_y}, type} -> type == :finite end)
      |> Enum.max_by(fn {{x, y}, _type} -> x * y end)
      |> IO.inspect
    end
  end

  defp closest_point(_point, _coordinates) do
    "bleep"
  end

  defp process_input(text) do
    text
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1==""))
    |> Enum.map(&process_line/1)
  end

  defp process_line(line) when is_binary(line) do
    with %{"i" => i, "j" => j} <- Regex.named_captures(~r/(?<i>\d+), (?<j>\d+)/, line),
      {i, ""} <- Integer.parse(i),
      {j, ""} <- Integer.parse(j),
      do: {i, j}
  end

  defp input do
    @input_file
    |> File.read!
  end
end
