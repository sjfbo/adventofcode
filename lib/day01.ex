defmodule(Calibration) do
  @spec sum_calibration_values(String.t()) :: integer()
  def sum_calibration_values(document) do
    document
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_calibration_values/1)
    |> Enum.sum()
  end

  @spec extract_calibration_values(String.t()) :: integer()
  defp extract_calibration_values(line) do
    digits = String.graphemes(line) |> Enum.filter(&(&1 =~ ~r/\d/))

    case digits do
      [first | _] = list when length(list) > 1 ->
        last = List.last(list)
        String.to_integer("#{first}#{last}")

      [single] ->
        String.to_integer("#{single}#{single}")

      _ ->
        0
    end
  end
end

input = File.read!("day01.txt")
IO.inspect(Calibration.sum_calibration_values(input))
