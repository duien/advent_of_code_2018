defmodule Mix.Tasks.Day do
  use Mix.Task
  @shortdoc "Run advent of code for day n"
  @days %{
    1 => AdventOfCode.ChronalCalibration,
    2 => AdventOfCode.InventoryManagementSystem
  }

  def run([day]) do
    with { day, _ } <- Integer.parse(day),
      mod <- Map.get(@days, day),
      {message_1, result_1} <- mod.part1(),
      {message_2, result_2} <- mod.part2()
      do
        Mix.shell.info """
          AdventOfCode -- #{to_string mod}

          Part 1: #{message_1}
          Answer: #{result_1}

          Part 2: #{message_2}
          Answer: #{result_2}
          """
    end
  end
  #
  # 
  #
  #
  #   case Integer.parse(day) do
  #     {1,_} ->
  #       Mix.shell.info "## Advent of Code :: Chronal Calibration"
  #       Mix.shell.info "\nWhat is the resulting frequency?"
  #       Mix.shell.info inspect(AdventOfCode.ChronalCalibration.part1())
  #       Mix.shell.info "\nWhat is the first frequency your device reaches twice?"
  #       Mix.shell.info inspect(AdventOfCode.ChronalCalibration.part2())
  #     _ ->
  #       Mix.shell.info "Nope"
  #   end
  # end

  def run(_) do
    Mix.shell.info "Nope"
  end
end
