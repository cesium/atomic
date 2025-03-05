[
  import_deps: [:ecto, :phoenix],
  plugins: [TailwindFormatter, DoctestFormatter, Phoenix.LiveView.HTMLFormatter],
  heex_line_length: 300,
  inputs: [
    "*.{heex,ex,exs}",
    "priv/*/seeds.exs",
    "priv/repo/seeds/*.exs",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "storybook/**/*.exs"
  ],
  subdirectories: ["priv/*/migrations"]
]
