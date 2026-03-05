type PublicSupabaseEnv = {
  url: string;
  anonKey: string;
};

function readRequiredEnv(key: "NEXT_PUBLIC_SUPABASE_URL" | "NEXT_PUBLIC_SUPABASE_ANON_KEY"): string {
  const value = process.env[key];
  if (!value) {
    throw new Error(`[supabase] Missing required environment variable: ${key}`);
  }
  return value;
}

export function getPublicSupabaseEnv(): PublicSupabaseEnv {
  return {
    url: readRequiredEnv("NEXT_PUBLIC_SUPABASE_URL"),
    anonKey: readRequiredEnv("NEXT_PUBLIC_SUPABASE_ANON_KEY"),
  };
}

export function getServiceRoleKey(): string {
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!key) {
    throw new Error("[supabase] Missing required environment variable: SUPABASE_SERVICE_ROLE_KEY");
  }
  return key;
}
