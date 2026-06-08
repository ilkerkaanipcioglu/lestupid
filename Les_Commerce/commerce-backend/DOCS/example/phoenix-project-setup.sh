# Create a new Phoenix project with LiveView
mix phx.new dukkadee --live
cd dukkadee

# Install dependencies
mix deps.get

# Create the database
mix ecto.create
