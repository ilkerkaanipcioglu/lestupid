type OpportunityAdapterMode = "mock" | "http";

function env(name: string, fallback: string): string {
  const value = import.meta.env[name];
  return typeof value === "string" && value.length > 0 ? value : fallback;
}

function adapterMode(value: string): OpportunityAdapterMode {
  return value === "http" ? "http" : "mock";
}

export const appConfig = {
  apiBaseUrl: env("VITE_LESTUPID_API_BASE_URL", "http://commerce-backend:4003"),
  lesMatchApiBaseUrl: env("VITE_LES_MATCH_API_BASE_URL", "http://commerce-backend:4003"),
  lesPokeApiBaseUrl: env("VITE_LES_POKE_API_BASE_URL", "http://commerce-backend:4003"),
  opportunityAdapter: adapterMode(env("VITE_OPPORTUNITY_ADAPTER", "mock"))
};

