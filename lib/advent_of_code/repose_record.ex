defmodule AdventOfCode.ReposeRecord do
  @input_file Application.app_dir(:advent_of_code, "priv/day_4.txt")

  @part1 "Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most? What is the ID of the guard you chose multiplied by the minute you chose?"
  @part2 "Of all guards, which guard is most frequently asleep on the same minute? What is the ID of the guard you chose multiplied by the minute you chose?"
  def part1, do: {@part1, &likely_sleeping/0}
  def part2, do: {@part2, &sleepiest_minute/0}

  # Strategy 1: Find the guard that has the most minutes asleep. What minute
  # does that guard spend asleep the most?
  #
  # Returns the ID multiplied by the minute
  #
  def likely_sleeping(schedule \\ input()) do
    {guard, minutes} = schedule
    |> prepare_schedule
    |> sleepiest_guard

    { minute, _ } = minutes
    |> Enum.group_by(&(&1))
    |> Enum.max_by(fn {_, m} -> Enum.count(m) end)

    IO.inspect(guard, label: "guard")
    IO.inspect(minute, label: "minute")
    guard * minute
  end

  def sleepiest_minute(schedule \\ input()) do
    {{guard, minute}, _} = schedule
    |> prepare_schedule
    |> guard_minutes
    |> Enum.map(fn {guard, minutes} ->
      minutes
     |> Enum.map(&({guard, &1}))
    end)
    |> List.flatten
    |> Enum.group_by(&(&1))
    |> Enum.max_by(fn {_, m} -> Enum.count(m) end)


    IO.inspect(guard, label: "guard")
    IO.inspect(minute, label: "minute")
    guard * minute
  end

  def guard_minutes(schedule) do
    schedule
    |> Enum.group_by(fn {g,_} -> g end, fn {_,s} -> s end)
    |> Enum.map(fn {guard, sleeps} ->
      minutes = sleeps
      |> List.flatten
      |> sleeping_minutes
      {guard, minutes}
    end)
  end

  # expects a prepared schedule like
  # [
  #   { 10, [{5, 15}, {27,31}] },
  #   { 99, [{40, 50}] },
  #   ...
  # ]
  def sleepiest_guard(schedule) do
    schedule
    |> guard_minutes
    |> Enum.max_by(fn {_,m} -> Enum.count(m) end)
  end

  # expects list of sleeps like
  # [{5, 25}, {30, 55}, {24, 29}]
  defp sleeping_minutes(sleeps) do
    sleeps
    |> Enum.map(fn {sleep, wake} -> Enum.to_list(sleep..wake-1) end)
    |> List.flatten
  end

  # accepts a big string, spits out sorted schedule lines grouped into guard shifts
  def prepare_schedule(schedule) do
    schedule
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.sort
    |> Enum.chunk_while([], &chunk_shifts/2, &({:cont, Enum.reverse(&1), []}))
    |> List.delete_at(0) # remove the empty chunk at the beginning
    |> Enum.map(&parse_shift/1)
  end

  defp chunk_shifts(item, acc) do
    if String.match?(item, ~r/begins shift/) do
      {:cont, Enum.reverse(acc), [item]}
    else
      {:cont, [item | acc]}
    end
  end

  @sleep_minute_regex ~r/\[\d{4}-\d{2}-\d{2} 00:(?<minute>\d{2})\]/
  @guard_regex ~r/Guard #(?<guard>\d+) begins shift/
  defp parse_shift([shift_start | shift]) do
    {guard, ""} = @guard_regex
    |> Regex.run(shift_start, capture: :all_but_first)
    |> Enum.at(0)
    |> Integer.parse

    sleeping_minutes = shift
    |> Enum.chunk_every(2)
    |> Enum.map(fn [asleep, awake] ->
       with [asleep] = Regex.run(@sleep_minute_regex, asleep, capture: :all_but_first),
         {asleep, ""} <- Integer.parse(asleep),
         [awake] = Regex.run(@sleep_minute_regex, awake, capture: :all_but_first),
         {awake, ""} <- Integer.parse(awake),
       do: {asleep, awake}
    end)

    {guard, sleeping_minutes}
  end

  defp input do
    @input_file
    |> File.read!
  end

end
