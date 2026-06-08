defmodule LesMatchApiWeb.Router do
  use LesMatchApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LesMatchApiWeb do
    pipe_through :api

    get "/health", HealthController, :show
    get "/identity/status", ActivationController, :identity_status
    get "/activations", ActivationController, :index
    post "/activations", ActivationController, :create
    patch "/activations/:product_id", ActivationController, :update
    delete "/activations/:product_id", ActivationController, :delete
    post "/opportunities", OpportunityController, :create
    post "/matches/preview", MatchController, :preview
    post "/matches/accept", MatchController, :accept
    post "/matches/reject", MatchController, :reject
    post "/safety/report", SafetyController, :report
  end

  scope "/", LesMatchApiWeb do
    pipe_through :api

    get "/agent-manifest.json", AgentManifestController, :show
    get "/.well-known/ai-agent.json", AgentManifestController, :show
    get "/.well-known/lestupid-app.json", AgentManifestController, :show
  end
end
