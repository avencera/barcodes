use Mix.Config

port =
  "PORT"
  |> System.get_env()
  |> Kernel.||("5000")
  |> String.to_integer()

logger_level =
  "DEBUG_LEVEL"
  |> System.get_env()
  |> Kernel.||("debug")
  |> String.to_atom()

config :logger, level: logger_level

config :barcodes, BarcodesWeb.Endpoint,
  http: [:inet6, port: port],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  url: [host: System.get_env("DOMAIN_NAME"), scheme: "https", port: 443]
