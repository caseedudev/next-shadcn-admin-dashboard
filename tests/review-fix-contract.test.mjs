import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import test from "node:test";

const ROOT = process.cwd();

function read(filePath) {
  return fs.readFileSync(path.join(ROOT, filePath), "utf8");
}

function readMigrations() {
  const migrationDir = path.join(ROOT, "supabase/migrations");
  return fs
    .readdirSync(migrationDir)
    .filter((name) => name.endsWith(".sql"))
    .sort()
    .map((name) => fs.readFileSync(path.join(migrationDir, name), "utf8"))
    .join("\n\n");
}

test("academies/academy_members 온보딩 insert 정책이 존재해야 한다", () => {
  const sql = readMigrations();

  assert.match(sql, /create policy\s+academies_insert_authenticated/i);
  assert.match(sql, /on\s+public\.academies/i);
  assert.match(sql, /for\s+insert/i);
  assert.match(sql, /create policy\s+academy_members_insert_self_owner/i);
  assert.match(sql, /on\s+public\.academy_members/i);
});

test("onboard 함수는 authenticated 사용자의 owner 위임을 막아야 한다", () => {
  const sql = read("supabase/migrations/20260305210000_academy_onboarding_function.sql");

  assert.match(sql, /v_actor_user_id uuid/i);
  assert.match(sql, /v_actor_user_id := \(select auth\.uid\(\)\)/i);
  assert.match(sql, /if v_actor_user_id is not null and p_owner_user_id <> v_actor_user_id then/i);
  assert.match(sql, /raise exception 'owner user id must match auth.uid\(\)'/i);
});

test("시드 SQL은 owner 계정 누락 시 예외를 발생시켜야 한다", () => {
  const sql = read("supabase/seeds/academy-onboarding-seed.sql");

  assert.match(sql, /do \$\$/i);
  assert.match(sql, /raise exception 'Missing auth\.users seed owner emails/i);
  assert.match(sql, /string_agg/i);
});

test("next 설정에는 turbopack.root가 명시되어야 한다", () => {
  const config = read("next.config.mjs");
  assert.match(config, /turbopack:\s*\{/);
  assert.match(config, /root:/);
});

test("로그인은 remember 입력 없이 일관된 동작을 가져야 한다", () => {
  const loginRoute = read("src/app/api/v1/auth/login/route.ts");
  const loginForm = read("src/app/(main)/auth/_components/login-form.tsx");

  assert.doesNotMatch(loginRoute, /remember/);
  assert.doesNotMatch(loginForm, /remember/);
});
