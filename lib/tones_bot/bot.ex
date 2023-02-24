defmodule TonesBot.Bot do
  @bot :tones_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  alias TonesBot.{Parser, MessageFormatter}

  require Logger

  command("start")
  command("help", description: "Muestra la ayuda del bot")
  command("tonalidad", description: "Te da la tonalidad de un acorde")
  command("about", description: "Información del creador")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    message = """
    Envía el comando `/tonalidad <nota> <modo>`, por ejemplo:
      - Do# Mayor
      - Re Menor

    _Nota del creador: Ten en cuenta que no soy un músico de verdad, solo soy un aficionado y puede haber tonalidades erróneas_
    """

    opts = [parse_mode: "Markdown"]

    answer(context, message, opts)
  end

  def handle({:command, :about, _msg}, context) do
    message = """
    _Este bot lo ha hecho [@Ironjanowar](https://github.com/Ironjanowar) con ❤️_

    Si quieres dar un poco de apoyo deja una estrella ⭐️ en el [repositorio](https://github.com/Ironjanowar/fxtwitter_bot)
    """

    opts = [parse_mode: "MarkdownV2"]

    answer(context, message, opts)
  end

  def handle({:command, :tonalidad, %{text: note}}, context) do
    case Parser.parse_note(note) do
      {:ok, tonality} ->
        formatted_message = MessageFormatter.tonality_to_message(tonality)
        answer(context, formatted_message, parse_mode: "Markdown")

      {:error, error} ->
        answer(context, error)
    end
  end

  def handle(_, _), do: Logger.info("Unhandled update")
end
