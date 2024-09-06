defmodule Claude do
  @moduledoc """
    Chat with Claude CLI
  """

  @api_url "https://api.anthropic.com/v1/messages"

  def start do
    IO.puts("Chatbot initialized. Type 'exit' to end the conversation.")
    chat_loop()
  end

  defp chat_loop do
    input = IO.gets("You: ") |> String.trim()

    if input == "exit" do
      IO.puts("Chatbot: Goodbye!")
    else
      case request_completion(input) do
        {:ok, response} ->
          IO.puts("Claude: #{response}")

        {:error, response} ->
          IO.puts("Error: #{inspect(response)}")
      end

      chat_loop()
    end
  end

  defp api_key do
    Application.get_env(:anthropic, :api_key) || raise("Anthropic API key is not set")
  end

  defp request_completion(input) do
    headers = [
      {"Content-Type", "application/json"},
      {"x-api-key", api_key()},
      {"anthropic-version", "2023-06-01"}
    ]

    body =
      Jason.encode!(%{
        "model" => "claude-3-5-sonnet-20240620",
        "max_tokens" => 1024,
        "messages" => [
          %{"role" => "user", "content" => input}
        ]
      })

    case HTTPoison.post(@api_url, body, headers) do
      {:ok, %{status_code: 200, body: response_body}} ->
        {:ok, extract_response(response_body)}

      {:ok, %{status_code: status_code, body: response_body}} ->
        {:error, "#{status_code} #{extract_error(response_body)}"}

      {:error, %{status_code: status_code, body: response_body}} ->
        {:error, "#{status_code} #{extract_error(response_body)}"}

      {:error, reason} ->
        {:error, inspect(reason)}

      _ ->
        {:error, %{reason: "Unknown error"}}
    end
  end

  defp extract_error(body) do
    body
    |> Jason.decode!()
    |> Map.get("error")
    |> Map.get("message")
  end

  defp extract_response(body) do
    body
    |> Jason.decode!()
    |> Map.get("content")
    |> List.first()
    |> Map.get("text")
  end
end
