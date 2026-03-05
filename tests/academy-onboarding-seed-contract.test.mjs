import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import test from "node:test";

const ROOT = process.cwd();

function read(filePath) {
  return fs.readFileSync(path.join(ROOT, filePath), "utf8");
}

function exists(filePath) {
  return fs.existsSync(path.join(ROOT, filePath));
}

test("academy onboarding 함수 마이그레이션이 존재해야 한다", () => {
  const filePath = "supabase/migrations/20260305210000_academy_onboarding_function.sql";
  assert.equal(exists(filePath), true);

  const sql = read(filePath);
  assert.match(sql, /create or replace function\s+public\.onboard_academy_owner/i);
  assert.match(sql, /insert into public\.academies/i);
  assert.match(sql, /on conflict\s*\(id\)\s*do nothing/i);
  assert.match(sql, /insert into public\.academy_members/i);
  assert.match(sql, /on conflict\s*\(academy_id,\s*user_id\)\s*do nothing/i);
});

test("idempotent seed SQL이 존재해야 한다", () => {
  const filePath = "supabase/seeds/academy-onboarding-seed.sql";
  assert.equal(exists(filePath), true);

  const sql = read(filePath);
  assert.match(sql, /with seed_rows as/i);
  assert.match(sql, /auth\.users/i);
  assert.match(sql, /onboard_academy_owner/i);
  assert.match(sql, /on conflict/i);
});
