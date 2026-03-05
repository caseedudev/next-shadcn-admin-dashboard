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

test("Supabase 클라이언트 계층 파일이 존재해야 한다", () => {
  assert.equal(exists("src/lib/supabase/env.ts"), true);
  assert.equal(exists("src/lib/supabase/server.ts"), true);
  assert.equal(exists("src/lib/supabase/client.ts"), true);
});

test("API route는 버저닝 + cursor pagination 패턴을 가져야 한다", () => {
  const route = read("src/app/api/v1/academy/enrollments/route.ts");
  assert.match(route, /export async function GET/);
  assert.match(route, /\.gt\("id", cursor\)/);
  assert.match(route, /limit\(limit \+ 1\)/);
  assert.match(route, /export async function POST/);
});

test("Supabase migration은 RLS + 인덱스 규칙을 포함해야 한다", () => {
  const migration = read("supabase/migrations/20260305170000_academy_enrollments.sql");
  assert.match(migration, /enable row level security/i);
  assert.match(migration, /force row level security/i);
  assert.match(migration, /create index/i);
  assert.match(migration, /select auth\.uid\(\)/i);
});

test("문서에는 모노레포 전환 규칙과 AI 체크리스트가 있어야 한다", () => {
  const doc = read("docs/architecture/supabase-route-and-monorepo-guide.md");
  assert.match(doc, /모노레포 전환 트리거/);
  assert.match(doc, /AI 작업 체크리스트/);
  assert.match(doc, /Supabase\/Route 패턴/);
});
