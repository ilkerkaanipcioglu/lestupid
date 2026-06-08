defmodule LesPokeApiWeb.Router do
  use LesPokeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LesPokeApiWeb do
    pipe_through :api

    get "/health", HealthController, :show
    get "/cities", CityController, :index
    get "/quests", QuestController, :index
    get "/quests/:id", QuestController, :show
  end

  scope "/", LesPokeApiWeb do
    pipe_through :api

    get "/agent-manifest.json", AgentManifestController, :show
    get "/.well-known/ai-agent.json", AgentManifestController, :show
    get "/.well-known/lestupid-app.json", AgentManifestController, :show
  end
end
