import Config

config :mogrify,
  mogrify_command: [
    path: "magick",
    args: ["mogrify"]
  ]

# config :mogrify,
#   convert_command: [
#     path: "magick",
#     args: ["convert"]
#   ]

# config :mogrify,
#   identify_command: [
#     path: "magick",
#     args: ["identify"]
#   ]

# import_config "#{config_env()}.exs"
# brew install ghostscript
