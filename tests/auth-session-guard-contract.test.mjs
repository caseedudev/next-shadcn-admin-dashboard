import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import test from "node:test";

const ROOT = process.cwd();

function read(filePath) {
  return fs.readFileSync(path.join(ROOT, filePath), "utf8");
}

test("proxy는 Supabase 세션으로 dashboard/auth 접근을 제어해야 한다", () => {
  const proxy = read("src/proxy.ts");
  assert.match(proxy, /createServerClient/);
  assert.match(proxy, /supabase\.auth\.getUser\(\)/);
  assert.match(proxy, /matcher:\s*\["\/dashboard\/:path\*", "\/auth\/:path\*"\]/);
});

test("dashboard layout은 세션 + academy_members 멤버십 가드를 적용해야 한다", () => {
  const layout = read("src/app/(main)/dashboard/layout.tsx");
  assert.match(layout, /createSupabaseServerClient/);
  assert.match(layout, /\.from\("academy_members"\)/);
  assert.match(layout, /\.eq\("user_id", user\.id\)/);
  assert.match(layout, /redirect\("\/auth\/v1\/login/);
  assert.match(layout, /redirect\("\/unauthorized"\)/);
});
