import Config

import_config "#{Mix.env()}.exs"

config :gate, decoder: Poison
