defmodule AdventOfCode.FabricSlicer do
  @input_file Application.app_dir(:advent_of_code, "priv/day_3.txt")

  @part1 "How many square inches of fabric are within two or more claims?"
  @part2 "What is the ID of the only claim that doesn't overlap?"
  def part1, do: {@part1, &claim_overlapping_area/0}
  def part2, do: {@part2, &workable_claim/0}

  defmodule Claim, do: defstruct [:id, :left, :top, :width, :height]

  @doc """
  Examples:

      iex> AdventOfCode.FabricSlicer.claim_overlapping_area(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"])
      4
  """
  def claim_overlapping_area(claims \\ input()) do
    {:ok, layout} = start_link()

    register_claims(layout, claims)
    Agent.get(layout, &(&1))
    |> Enum.filter(fn {{_,_}, claims} -> MapSet.size(claims) > 1 end)
    |> Enum.count
  end

  @doc """
  Examples:

      iex> AdventOfCode.FabricSlicer.workable_claim(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"])
      3
  """
  def workable_claim(claims \\ input()) do
    {:ok, layout} = start_link()

    register_claims(layout, claims)
    overlapping = Agent.get(layout, &(&1))
    |> Map.values
    |> Enum.group_by(fn claims ->
      MapSet.size(claims) > 1
    end)
    |> Enum.map(fn {k, claims} -> {k, Enum.reduce(claims, &MapSet.union(&1, &2))} end)
    |> Enum.into(%{})

    [workable] = MapSet.difference(overlapping[false], overlapping[true])
    |> MapSet.to_list
    workable.id
  end

  def register_claims(layout, claims) do
    claims
    |> Enum.map(&parse(&1))
    |> Enum.each(&register_claim(layout, &1))
  end

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def register_claim(layout, claim = %Claim{}) do
    for x <- claim.left..(claim.left + claim.width - 1),
        y <- claim.top..(claim.top + claim.height - 1)
    do
      Agent.update(layout, fn state ->
        Map.update(state, {x,y}, MapSet.new([claim]), &MapSet.put(&1, claim))
      end)
    end
  end


  defp input do
    @input_file
    |> File.stream!
    |> Enum.map(&String.trim(&1))
  end

  @claim_regex ~r/#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/
  def parse(claim) do
    with captures = Regex.named_captures(@claim_regex, claim),
      # %{ "id" => id, "left" => left, "top" => top, "width" => width, "height" => height } = captures,
      {id, ""} <- Integer.parse(Map.get(captures, "id")),
      {left, ""} <- Integer.parse(Map.get(captures, "left")),
      {top, ""} <- Integer.parse(Map.get(captures, "top")),
      {width, ""} <- Integer.parse(Map.get(captures, "width")),
      {height, ""} <- Integer.parse(Map.get(captures, "height")),
    do: %Claim{id: id, left: left, top: top, width: width, height: height}
  end
end
