defmodule Chatbot do
  @moduledoc """
  Documentation for `Chatbot`.
  """

  def respond(input) do
    input
    |> String.trim()
    |> String.downcase()
    |> handle_response()
  end

  def start do
    IO.puts("Hello! How may I help you?")
    loop()
  end

  defp handle_response("hello") do
    "Hello. How may I help you?"
  end

  defp handle_response("goodbye") do
    "Goodbye. Have a great day!"
  end

  defp handle_response(_input) do
    "I'm sorry, I don't understand you."
  end

  defp loop do
    input = IO.gets("Msg: ") |> String.trim()

    if input == "quit" do
      IO.puts("Goodbye!")
    else
      IO.puts(Chatbot.respond(input))
      loop()
    end
  end
end
