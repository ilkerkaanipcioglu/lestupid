ExUnit.start()

# Disable Ecto for tests
Application.put_env(:dukkadee, :ecto_repos, [])
