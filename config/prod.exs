use Mix.Config

config :barcodes, BarcodesWeb.Endpoint,
  server: true,
  root: ".",
  cache_static_manifest: "priv/static/cache_manifest.json"

import_config "prod.secret.exs"
