import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import test from "node:test";

const ROOT = process.cwd();
const MIGRATIONS_DIR = path.join(ROOT, "supabase/migrations");

function readAllMigrations() {
  const files = fs
    .readdirSync(MIGRATIONS_DIR)
    .filter((name) => name.endsWith(".sql"))
    .sort();

  return files.map((file) => fs.readFileSync(path.join(MIGRATIONS_DIR, file), "utf8")).join("\n\n");
}

test("academy membership-related user columns should reference auth.users", () => {
  const sql = readAllMigrations();

  assert.match(sql, /academy_members_user_id_fkey/i);
  assert.match(sql, /foreign key\s*\(user_id\)\s*[\s\S]*references\s+auth\.users\(id\)/i);
  assert.match(sql, /academy_enrollments_created_by_fkey/i);
  assert.match(sql, /foreign key\s*\(created_by\)\s*[\s\S]*references\s+auth\.users\(id\)/i);
});

test("academies table should have RLS enabled and membership-based select policy", () => {
  const sql = readAllMigrations();

  assert.match(sql, /alter table\s+public\.academies\s+enable row level security/i);
  assert.match(sql, /alter table\s+public\.academies\s+force row level security/i);
  assert.match(sql, /create policy\s+academies_select_by_membership/i);
  assert.match(sql, /from\s+public\.academy_members/i);
  assert.match(sql, /\(select\s+auth\.uid\(\)\)/i);
});
