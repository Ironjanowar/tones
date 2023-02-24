defmodule TonesBot.Parser do
  def is_valid_type?(type), do: String.downcase(type) in ["mayor", "menor", "major", "minor"]

  def format_type(type) do
    if String.downcase(type) in ["major", "mayor"] do
      :major
    else
      :minor
    end
  end

  @error_message "That chord is not valid, send /help to see some examples"
  def parse_note(note) do
    case String.split(note, " ", trim: true) do
      [note, type] ->
        if TonesBot.to_number(note) != :error and is_valid_type?(type) do
          formatted_type = format_type(type)
          {:ok, TonesBot.tonality(note, formatted_type)}
        else
          {:error, @error_message}
        end

      _ ->
        {:error, @error_message}
    end
  end
end
