defmodule TonesBot.MessageFormatter do
  def number_to_grade(1), do: "I"
  def number_to_grade(2), do: "II"
  def number_to_grade(3), do: "III"
  def number_to_grade(4), do: "IV"
  def number_to_grade(5), do: "V"
  def number_to_grade(6), do: "VI"
  def number_to_grade(7), do: "VII"
  def number_to_grade(_), do: :error

  def tonality_to_message(tonality) do
    chords =
      tonality
      |> Enum.zip(1..7)
      |> Enum.map(fn {chord, grade} ->
        grade_with_padding = grade |> number_to_grade() |> String.pad_leading(5)
        "`#{grade_with_padding} - #{chord}`"
      end)
      |> Enum.join("\n")

    """
    The tonality is:
    #{chords}
    """
  end
end
