type AdapterMode = "mock" | "http";

function env(name: string, fallback: string): string {
  const value = import.meta.env[name];
  return typeof value === "string" && value.length > 0 ? value : fallback;
}

function adapterMode(value: string): AdapterMode {
  return value === "http" ? "http" : "mock";
}

export const appConfig = {
  apiBaseUrl: env("VITE_LESTUPID_API_BASE_URL", "http://127.0.0.1:4000"),
  lesContactsApiBaseUrl: env("VITE_LES_CONTACTS_API_BASE_URL", "http://127.0.0.1:4004"),
  lesMatchApiBaseUrl: env("VITE_LES_MATCH_API_BASE_URL", "http://127.0.0.1:4002"),
  lesPokeApiBaseUrl: env("VITE_LES_POKE_API_BASE_URL", "http://127.0.0.1:4003"),
  coreAdapter: adapterMode(env("VITE_CORE_ADAPTER", "mock")),
  opportunityAdapter: adapterMode(env("VITE_OPPORTUNITY_ADAPTER", "mock"))
};
