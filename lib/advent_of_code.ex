defmodule AdventOfCode do

  @days %{
    1 => AdventOfCode.ChronalCalibration,
    2 => AdventOfCode.InventoryManagementSystem,
    3 => AdventOfCode.FabricSlicer,
    4 => AdventOfCode.ReposeRecord
  }

  @doc """
  Returns the module for the given day number
  """
  def day(n) do
    Map.get(@days, n)
  end

  def days do
    @days
    |> Map.values
  end
end
