defmodule Mix.Tasks.Day do
  use Mix.Task
  @shortdoc "Run advent of code for day n"

  def run([day]) do
    Mix.shell.print_app()
    case Integer.parse(day) do
      {1,_} ->
        Mix.shell.info "## Advent of Code :: Chronal Calibration"
        Mix.shell.info "\nWhat is the resulting frequency?"
        Mix.shell.info inspect(AdventOfCode.ChronalCalibration.part1())
        Mix.shell.info "\nWhat is the first frequency your device reaches twice?"
        Mix.shell.info inspect(AdventOfCode.ChronalCalibration.part2())
      _ ->
        Mix.shell.info "Nope"
    end
  end

  def run(_) do
    Mix.shell.info "Nope"
  end
end
