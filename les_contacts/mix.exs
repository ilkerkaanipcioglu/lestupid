defmodule LesContacts.MixProject do
  use Mix.Project

  def project do
    [
      app: :les_contacts,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {LesContacts.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:les_core, path: "../les_core"},
      {:plug, "~> 1.16"},
      {:plug_cowboy, "~> 2.7"},
      {:jason, "~> 1.4"}
    ]
  end
end
