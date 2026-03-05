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

test("Turborepo 도입 규칙 문서가 존재해야 한다", () => {
  const filePath = "docs/architecture/turborepo-adoption-rules.md";
  assert.equal(exists(filePath), true);

  const doc = read(filePath);
  assert.match(doc, /도입 트리거/);
  assert.match(doc, /의존 방향 규칙/);
  assert.match(doc, /앱\/패키지 구조 템플릿/);
});

test("현재 반영 구조 스냅샷 문서가 존재해야 한다", () => {
  const filePath = "docs/architecture/current-implemented-structure.md";
  assert.equal(exists(filePath), true);

  const doc = read(filePath);
  assert.match(doc, /현재 반영 구조 스냅샷/);
  assert.match(doc, /인증 \/ 세션 \/ 권한 가드/);
  assert.match(doc, /Supabase 스키마 \/ RLS \/ 마이그레이션/);
  assert.match(doc, /테스트 계약/);
});

test("프로젝트 개발 규칙 문서가 존재해야 한다", () => {
  const filePath = "docs/architecture/development-rules.md";
  assert.equal(exists(filePath), true);

  const doc = read(filePath);
  assert.match(doc, /스택 고정값/);
  assert.match(doc, /아키텍처 규칙/);
  assert.match(doc, /Supabase Auth\/DB 규칙/);
  assert.match(doc, /React\/Next 성능 규칙/);
  assert.match(doc, /AI 작업 체크리스트/);
});

test("Next.js best case 규칙 문서가 존재해야 한다", () => {
  const filePath = "docs/architecture/nextjs-best-case-rules.md";
  assert.equal(exists(filePath), true);

  const doc = read(filePath);
  assert.match(doc, /기술 스택 역할 분리/);
  assert.match(doc, /Next\.js \/ React 성능 규칙/);
  assert.match(doc, /컴포넌트 설계 규칙/);
  assert.match(doc, /UI\/UX\/접근성 규칙/);
  assert.match(doc, /데이터\/인증 규칙/);
  assert.match(doc, /PR\/AI 체크리스트/);
});
