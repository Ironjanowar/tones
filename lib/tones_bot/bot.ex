defmodule TonesBot.Bot do
  @bot :tones_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  alias TonesBot.{Parser, MessageFormatter}

  command("start")
  command("help", description: "Print the bot's help")
  command("tonality", description: "Gets the tonality for a note")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Send the command /tonality <note>, for example:\n  Do# Mayor\n  Re Menor")
  end

  def handle({:command, :tonality, %{text: note}}, context) do
    case Parser.parse_note(note) do
      {:ok, tonality} ->
        formatted_message = MessageFormatter.tonality_to_message(tonality)
        answer(context, formatted_message, parse_mode: "Markdown")

      {:error, error} ->
        answer(context, error)
    end
  end
end
