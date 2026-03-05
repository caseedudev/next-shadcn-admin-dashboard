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

test("auth API routes should exist", () => {
  assert.equal(exists("src/app/api/v1/auth/login/route.ts"), true);
  assert.equal(exists("src/app/api/v1/auth/register/route.ts"), true);
});

test("login/register forms should submit to API routes instead of mock toast", () => {
  const loginForm = read("src/app/(main)/auth/_components/login-form.tsx");
  const registerForm = read("src/app/(main)/auth/_components/register-form.tsx");

  assert.match(loginForm, /\/api\/v1\/auth\/login/);
  assert.match(registerForm, /\/api\/v1\/auth\/register/);

  assert.doesNotMatch(loginForm, /You submitted the following values/);
  assert.doesNotMatch(registerForm, /You submitted the following values/);
});

test("proxy should enforce auth redirects for dashboard and auth screens", () => {
  assert.equal(exists("src/proxy.ts"), true);
  const proxy = read("src/proxy.ts");

  assert.match(proxy, /createServerClient/);
  assert.match(proxy, /pathname\.startsWith\("\/dashboard"\)/);
  assert.match(proxy, /pathname\.startsWith\("\/auth"\)/);
  assert.match(proxy, /NextResponse\.redirect/);
});
