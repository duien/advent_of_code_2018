defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode.ChronalCalibration
  doctest AdventOfCode.InventoryManagementSystem
  doctest AdventOfCode.FabricSlicer
  doctest AdventOfCode.ReposeRecord

  describe "ReposeRecord" do
    setup do
      input = """
        [1518-11-01 00:00] Guard #10 begins shift
        [1518-11-01 00:05] falls asleep
        [1518-11-01 00:25] wakes up
        [1518-11-01 00:30] falls asleep
        [1518-11-01 00:55] wakes up
        [1518-11-01 23:58] Guard #99 begins shift
        [1518-11-02 00:40] falls asleep
        [1518-11-02 00:50] wakes up
        [1518-11-03 00:05] Guard #10 begins shift
        [1518-11-03 00:24] falls asleep
        [1518-11-03 00:29] wakes up
        [1518-11-04 00:02] Guard #99 begins shift
        [1518-11-04 00:36] falls asleep
        [1518-11-04 00:46] wakes up
        [1518-11-05 00:03] Guard #99 begins shift
        [1518-11-05 00:45] falls asleep
        [1518-11-05 00:55] wakes up
        """
      { :ok, input: input }
    end

    # Adding manual tests for ReposeRecord instead of just doctest
    test "likely sleeping guard", %{input: input} do
      assert AdventOfCode.ReposeRecord.likely_sleeping(input) == 240
    end

    test "sleepiest guard", %{input: input} do
      prepared_schedule = AdventOfCode.ReposeRecord.prepare_schedule(input)
      { guard, _minutes } = AdventOfCode.ReposeRecord.sleepiest_guard(prepared_schedule)
      assert guard == 10
    end

    test "sleepiest minute", %{input: input} do
      assert AdventOfCode.ReposeRecord.sleepiest_minute(input) == 4455
    end
  end
end
