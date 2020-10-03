defmodule TonesBot do
  def to_range(n), do: Integer.mod(n, 12)

  def to_note(n) do
    case to_range(n) do
      0 -> "Do"
      1 -> "Do#"
      2 -> "Re"
      3 -> "Re#"
      4 -> "Mi"
      5 -> "Fa"
      6 -> "Fa#"
      7 -> "Sol"
      8 -> "Sol#"
      9 -> "La"
      10 -> "La#"
      11 -> "Si"
      _ -> :error
    end
  end

  def to_number(note) do
    case String.downcase(note) do
      "do" -> 0
      "do#" -> 1
      "reb" -> 1
      "re" -> 2
      "re#" -> 3
      "mib" -> 3
      "mi" -> 4
      "fa" -> 5
      "fa#" -> 6
      "solb" -> 6
      "sol" -> 7
      "sol#" -> 8
      "lab" -> 8
      "la" -> 9
      "la#" -> 10
      "sib" -> 10
      "si" -> 11
      _ -> :error
    end
  end

  def major_third(note), do: (note + 4) |> to_range
  def minor_third(note), do: (note + 3) |> to_range

  def tone(note, :plus), do: (note + 2) |> to_range
  def tone(note, :minus), do: (note - 2) |> to_range
  def semitone(note, :plus), do: (note + 1) |> to_range
  def semitone(note, :minus), do: (note - 1) |> to_range

  def triad(note, :major) do
    n = to_number(note)
    third = major_third(n)
    fifth = minor_third(third)
    %{chord: major(note), triad: {note, to_note(third), to_note(fifth)}}
  end

  def triad(note, :minor) do
    n = to_number(note)
    third = minor_third(n)
    fifth = major_third(third)
    %{chord: minor(note), triad: {note, to_note(third), to_note(fifth)}}
  end

  def first_grade(note), do: note
  def second_grade(note), do: tone(note, :plus)
  def third_grade(note), do: note |> second_grade() |> tone(:plus)
  def forth_grade(note), do: note |> third_grade() |> semitone(:plus)
  def fifth_grade(note), do: note |> forth_grade() |> tone(:plus)
  def sixth_grade(note), do: note |> fifth_grade() |> tone(:plus)
  def seventh_grade(note), do: note |> sixth_grade() |> tone(:plus)
  def eight_grade(note), do: note |> seventh_grade() |> semitone(:plus)

  def major(note), do: "#{note} Mayor"
  def minor(note), do: "#{note} Menor"
  def semi(note), do: "#{note} Disminuido"

  def plus(a, b), do: a + b

  def tonality(note, :major) do
    n = to_number(note)

    [
      first_grade(n) |> to_note() |> major(),
      second_grade(n) |> to_note() |> minor(),
      third_grade(n) |> to_note() |> minor(),
      forth_grade(n) |> to_note() |> major(),
      fifth_grade(n) |> to_note() |> major(),
      sixth_grade(n) |> to_note() |> minor(),
      seventh_grade(n) |> to_note() |> semi(),
      eight_grade(n) |> to_note() |> major()
    ]
  end

  def tonality(note, :minor),
    do: to_number(note) |> plus(3) |> to_range() |> to_note() |> tonality(:major)
end
