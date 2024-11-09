defmodule Calibration do
  @spec sum_calibration_values(String.t(), :part1 | :part2) :: integer()
  def sum_calibration_values(document, part) do
    document
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_calibration_values(&1, part))
    |> Enum.sum()
  end

  @spec extract_calibration_values(String.t(), :part1 | :part2) :: integer()
  defp extract_calibration_values(line, :part1), do: extract_calibration_values_part_1(line)
  defp extract_calibration_values(line, :part2), do: extract_calibration_values_part_2(line)

  # part 1 specific extraction logic
  @spec extract_calibration_values_part_1(String.t()) :: integer()
  defp extract_calibration_values_part_1(line) do
    line
    |> String.graphemes()
    |> Enum.filter(&(&1 =~ ~r/\d/))
    |> get_calibration_value()
  end

  # part 2 specific extraction logic, with spelled-out number conversion
  @spec extract_calibration_values_part_2(String.t()) :: integer()
  defp extract_calibration_values_part_2(line) do
    line
    |> find_all_numbers()
    |> get_calibration_value()
  end

  @spec find_all_numbers(String.t()) :: [digit_string()]
  defp find_all_numbers(line) do
    word_patterns = %{
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9",
      "\\d" => "\\d"
    }

    pattern =
      [
        # match any digit
        "\\d",
        # match any number word
        Enum.join(Map.keys(word_patterns), "|")
      ]
      |> Enum.join("|")

    Regex.scan(~r/(?=(#{pattern}))/, line)
    |> Enum.map(fn [_, match] ->
      case Integer.parse(match) do
        # it's already a digit
        {_num, ""} -> match
        # it's a word
        _ -> Map.get(word_patterns, match)
      end
    end)
  end

  @spec get_calibration_value([String.t()]) :: non_neg_integer()
  defp get_calibration_value(digits) do
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

# run part 1
input_part1 = File.read!("./inputs/day01_part1.txt")
IO.inspect(Calibration.sum_calibration_values(input_part1, :part1), label: "Part 1 Sum")

# run part 2
input_part2 = File.read!("./inputs/day01_part2.txt")
IO.inspect(Calibration.sum_calibration_values(input_part2, :part2), label: "Part 2 Sum")
