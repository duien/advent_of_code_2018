defmodule Mix.Tasks.Day do
  use Mix.Task
  @shortdoc "Run advent of code for day n [part n]"

  def run([day, part]) do
    Mix.Task.run("compile")
    Mix.shell.info "\n#{IO.ANSI.reverse} Day #{day} - Part #{part} #{IO.ANSI.reverse_off}"
    try do
      with {day, "" } <- Integer.parse(day),
        { part, "" } <- Integer.parse(part),
        module <- AdventOfCode.day(day),
        func <- :"part#{part}",
      do: print_result apply(module, func, [])
    rescue e -> Mix.shell.error Exception.format(:error, e)
    end
  end

  def run([day]) do
    run([day, "1"])
    run([day, "2"])
  end

  def run(args) do
    Mix.raise "Nope"
    Mix.shell.debug args
  end

  defp print_result({message, result}) do
    Mix.shell.info "#{IO.ANSI.italic}#{message}#{IO.ANSI.reset}"
    Mix.shell.info "\nAnswer: #{IO.ANSI.bright}#{result.()}#{IO.ANSI.reset}"
  end
end
