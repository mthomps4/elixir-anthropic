import Config

# hack but it works for now...
unless Config.config_env() == :prod do
  File.stream!(".env")
  |> Stream.map(&String.trim/1)
  |> Stream.reject(&String.starts_with?(&1, "#"))
  |> Stream.map(&String.split(&1, "=", parts: 2))
  |> Enum.each(fn [key, value] -> System.put_env(key, value) end)
end

config :anthropic,
  api_key: System.get_env("ANTHROPIC_API_KEY") || raise("ANTHROPIC_API_KEY is not set")
