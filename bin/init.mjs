#!/usr/bin/env node
// recruit-kit / init.mjs
// Interview → placeholder substitution → scaffold a recruitment assignment workspace.
// Zero dependencies. Node >= 18.

import { readFile, writeFile, mkdir, readdir, stat, copyFile, rm } from 'node:fs/promises';
import { existsSync } from 'node:fs';
import { join, relative, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createInterface } from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';
import { execSync } from 'node:child_process';

const __dirname = dirname(fileURLToPath(import.meta.url));
const KIT_ROOT = resolve(__dirname, '..');
const TEMPLATE_DIR = join(KIT_ROOT, 'template');
const CLAUDE_SRC_DIR = join(KIT_ROOT, '.claude');

// ---------- arg parse ----------
const args = process.argv.slice(2);
const flags = {
  target: '.',
  dryRun: false,
  quiet: false,
  help: false,
};
for (let i = 0; i < args.length; i++) {
  const a = args[i];
  if (a === '--help' || a === '-h') flags.help = true;
  else if (a === '--dry-run') flags.dryRun = true;
  else if (a === '--quiet') flags.quiet = true;
  else if (a === '--target') flags.target = args[++i] ?? '.';
  else if (!a.startsWith('-')) flags.target = a;
}

if (flags.help) {
  console.log(`recruit-kit init — scaffold a recruitment assignment workspace.

Usage:
  node bin/init.mjs [target] [options]
  npx degit JayKim88/recruit-kit my-task && node my-task/bin/init.mjs

Options:
  --target <path>    Target directory (default: current directory)
  --dry-run          Print plan without writing
  --quiet            Skip interview, leave all {{VAR}} as-is (manual fill mode)
  --help, -h         Show this message

The interview will ask for:
  COMPANY, PRODUCT, ROLE, TASK_TYPE (FE|BE|FS|ML|Mobile|Other),
  DEADLINE_DATE (YYYY-MM-DD), DEADLINE_TIME, ONELINE_CHALLENGE, STACK_HINT,
  evaluation criteria (N items, each: name + points), ENV_NOTES.

After substitution, the script copies template/ + .claude/ into target,
then runs 'git init' and creates the first commit.
`);
  process.exit(0);
}

// ---------- interview ----------
const rl = createInterface({ input, output });

async function ask(question, defaultValue) {
  const suffix = defaultValue !== undefined ? ` [${defaultValue}]` : '';
  const answer = (await rl.question(`${question}${suffix}: `)).trim();
  return answer === '' && defaultValue !== undefined ? defaultValue : answer;
}

function todayISO() {
  const d = new Date();
  return d.toISOString().slice(0, 10);
}

function daysBetween(fromISO, toISO) {
  const from = new Date(fromISO + 'T00:00:00Z');
  const to = new Date(toISO + 'T00:00:00Z');
  return Math.round((to - from) / (1000 * 60 * 60 * 24));
}

async function runInterview() {
  console.log('\n=== recruit-kit interview ===\n');
  console.log('답변은 한국어/영어 자유. 빈 값이면 기본값 사용.\n');

  const COMPANY = await ask('회사명 (COMPANY)', 'AcmeCo');
  const PRODUCT = await ask('제품/과제 이름 (PRODUCT)', 'Take-Home Assignment');
  const ROLE = await ask('역할 (ROLE)', 'Software Engineer');
  const TASK_TYPE = await ask('과제 유형 (TASK_TYPE: FE|BE|FS|ML|Mobile|Other)', 'FE');
  const DEADLINE_DATE = await ask('마감일 (DEADLINE_DATE, YYYY-MM-DD)', todayISO());
  if (!/^\d{4}-\d{2}-\d{2}$/.test(DEADLINE_DATE)) {
    console.warn(`⚠ DEADLINE_DATE "${DEADLINE_DATE}" 가 YYYY-MM-DD 형식이 아닙니다. 그대로 진행하지만 일정 계산이 부정확할 수 있습니다.`);
  }
  const DEADLINE_TIME = await ask('마감 시각 (DEADLINE_TIME)', '23:59');
  const ONELINE_CHALLENGE = await ask('한 줄 핵심 도전 과제 (ONELINE_CHALLENGE)', '핵심 도메인 로직 + 상태 분리');
  const STACK_HINT = await ask('기술 스택 힌트 (STACK_HINT, free-form)', 'TypeScript + React + Vitest');
  const ENV_NOTES = await ask('환경 주의사항 (ENV_NOTES, 없으면 빈 입력)', '특이사항 없음 (표준 환경).');

  console.log('\n--- 실행 명령 (선택, 모르면 빈 입력 → placeholder 유지) ---');
  const TECH_RUNTIME = await ask('런타임 (TECH_RUNTIME, 예: Node.js / Python / Java)', '');
  const RUNTIME_VERSION = await ask('런타임 버전 (RUNTIME_VERSION, 예: 22.19 / 3.13 / 21)', '');
  const INSTALL_COMMAND = await ask('설치 명령 (INSTALL_COMMAND, 예: npm install / poetry install)', '');
  const DEV_COMMAND = await ask('개발 서버 명령 (DEV_COMMAND, 예: npm run dev)', '');
  const TEST_COMMAND = await ask('테스트 명령 (TEST_COMMAND, 예: npm test)', '');
  const BUILD_COMMAND = await ask('빌드 명령 (BUILD_COMMAND, 예: npm run build / 없으면 빈 입력)', '');

  console.log('\n--- 평가 기준 입력 ---');
  console.log('회사 명세에서 평가 기준 카테고리를 N개 입력합니다. (보통 5-7개)');
  const nStr = await ask('평가 기준 개수 (CRITERIA_COUNT)', '6');
  const n = Math.max(1, parseInt(nStr, 10) || 6);

  const criteria = [];
  for (let i = 1; i <= n; i++) {
    const name = await ask(`§${i} 카테고리명 (예: "요구사항 이해 및 문제 정의")`, `평가 항목 ${i}`);
    const pts = await ask(`§${i} 배점 (숫자만)`, '20');
    const parsed = parseInt(pts, 10);
    if (Number.isNaN(parsed) || parsed < 0) {
      console.warn(`⚠ §${i} 배점 "${pts}" 가 유효한 숫자가 아닙니다. 0으로 설정.`);
    }
    criteria.push({ index: i, name, points: Number.isNaN(parsed) ? 0 : parsed });
  }
  const totalPoints = criteria.reduce((s, c) => s + c.points, 0);
  console.log(`\n총 배점: ${totalPoints}점 (${criteria.length}개 카테고리)`);

  // detect doc/git criterion indices by name keyword
  const docIdx = criteria.findIndex(c => /문서|문서화|documentation|문서 화/i.test(c.name));
  const gitIdx = criteria.findIndex(c => /git|작업 흔적|커밋/i.test(c.name));
  const designIdx = criteria.findIndex(c => /설계|구조|design|architecture/i.test(c.name));
  const reqIdx = criteria.findIndex(c => /요구|이해|requirement|문제 정의/i.test(c.name));

  return {
    COMPANY,
    PRODUCT,
    ROLE,
    TASK_TYPE,
    DEADLINE_DATE,
    DEADLINE_TIME,
    DEADLINE_DAYS: String(Math.max(0, daysBetween(todayISO(), DEADLINE_DATE))),
    DAY_BEFORE_LAST: String(Math.max(0, daysBetween(todayISO(), DEADLINE_DATE) - 1)),
    TODAY: todayISO(),
    ONELINE_CHALLENGE,
    STACK_HINT,
    ENV_NOTES,
    TECH_RUNTIME,
    RUNTIME_VERSION,
    INSTALL_COMMAND,
    DEV_COMMAND,
    TEST_COMMAND,
    BUILD_COMMAND,
    EVAL_CRITERIA_TABLE: buildCriteriaTable(criteria),
    DOC_CRITERION_INDEX: docIdx >= 0 ? String(docIdx + 1) : 'N',
    GIT_CRITERION_INDEX: gitIdx >= 0 ? String(gitIdx + 1) : 'N',
    DESIGN_CRITERION_INDEX: designIdx >= 0 ? String(designIdx + 1) : '2',
    REQ_CRITERION_INDEX: reqIdx >= 0 ? String(reqIdx + 1) : '1',
    // numeric points P1..P9
    ...Object.fromEntries(criteria.map((c, i) => [`P${i + 1}`, String(c.points)])),
  };
}

function buildCriteriaTable(criteria) {
  return criteria.map(c => {
    return `### ${c.index}) ${c.name} (${c.points}점)

<!-- HINT: 이 카테고리에서 봐야 할 애매한 지점 / 체크포인트를 회사 명세 그대로 옮긴다. -->

| 체크포인트 | 낮은 숙련도 | 높은 숙련도 |
|---|---|---|
| ... | ... | ... |`;
  }).join('\n\n');
}

// ---------- template walk + substitute ----------
async function* walk(dir) {
  for (const name of await readdir(dir)) {
    const full = join(dir, name);
    const s = await stat(full);
    if (s.isDirectory()) yield* walk(full);
    else yield full;
  }
}

function substitute(content, vars) {
  return content.replace(/\{\{(\w+)\}\}/g, (match, key) => {
    return key in vars ? vars[key] : match; // keep unknown placeholders as-is
  });
}

function destPath(srcPath, vars) {
  const rel = relative(TEMPLATE_DIR, srcPath);
  // strip .tpl suffix
  const stripped = rel.endsWith('.tpl') ? rel.slice(0, -4) : rel;
  return join(resolve(flags.target), stripped);
}

async function copyDir(src, dst) {
  await mkdir(dst, { recursive: true });
  for (const name of await readdir(src)) {
    const s = join(src, name);
    const d = join(dst, name);
    const st = await stat(s);
    if (st.isDirectory()) await copyDir(s, d);
    else await copyFile(s, d);
  }
}

// ---------- main ----------
async function main() {
  const target = resolve(flags.target);

  if (!existsSync(KIT_ROOT) || !existsSync(TEMPLATE_DIR)) {
    console.error(`error: template not found at ${TEMPLATE_DIR}`);
    process.exit(1);
  }

  if (existsSync(target) && (await readdir(target)).filter(f => !['.git', 'node_modules', '.DS_Store'].includes(f)).length > 0) {
    if (relative(target, KIT_ROOT) === '' || target === KIT_ROOT) {
      console.error(`error: target is recruit-kit itself. Use 'npx degit JayKim88/recruit-kit my-task && cd my-task && node bin/init.mjs' instead.`);
      process.exit(1);
    }
    if (!flags.quiet) {
      const proceed = await ask(`target ${target} 가 비어있지 않습니다. 진행? (y/N)`, 'N');
      if (proceed.toLowerCase() !== 'y') {
        console.log('취소.');
        process.exit(0);
      }
    }
  }

  let vars = {};
  if (!flags.quiet) {
    vars = await runInterview();
  }
  rl.close();

  await mkdir(target, { recursive: true });

  // process template files
  const written = [];
  for await (const src of walk(TEMPLATE_DIR)) {
    const content = await readFile(src, 'utf8');
    const substituted = substitute(content, vars);
    const dst = destPath(src, vars);
    await mkdir(dirname(dst), { recursive: true });
    if (flags.dryRun) {
      written.push({ dst, bytes: substituted.length });
    } else {
      await writeFile(dst, substituted, 'utf8');
      written.push({ dst, bytes: substituted.length });
    }
  }

  // copy .claude/
  const claudeDst = join(target, '.claude');
  if (existsSync(CLAUDE_SRC_DIR)) {
    if (flags.dryRun) {
      written.push({ dst: claudeDst, bytes: -1, note: 'directory copy (skipped in dry-run)' });
    } else {
      await copyDir(CLAUDE_SRC_DIR, claudeDst);
    }
  }

  // remove the kit-internal bin/ if scaffolding into a fresh target inheriting from kit (degit case)
  // (degit creates a copy with bin/ included; we want the user to NOT have bin/init.mjs in their assignment repo)
  const targetBin = join(target, 'bin');
  if (!flags.dryRun && existsSync(targetBin) && resolve(targetBin) !== resolve(__dirname)) {
    const binFiles = await readdir(targetBin);
    if (binFiles.includes('init.mjs')) {
      // user came from degit; remove their inherited bin/init.mjs to keep their repo clean
      await rm(targetBin, { recursive: true, force: true });
    }
  }

  // also remove kit-internal docs/, package.json, README.md (kit's own), LICENSE if they got copied via degit
  if (!flags.dryRun) {
    for (const kitFile of ['docs/design-rationale.md', 'docs/workflow-guide.md', 'docs/customizing.md']) {
      const p = join(target, kitFile);
      if (existsSync(p)) await rm(p, { force: true });
    }
    // examples/ is kit-internal too
    const exDir = join(target, 'examples');
    if (existsSync(exDir)) await rm(exDir, { recursive: true, force: true });
  }

  // summary
  console.log('\n=== scaffold complete ===');
  console.log(`Target: ${target}`);
  console.log(`Files: ${written.length}`);
  for (const w of written.slice(0, 20)) console.log(`  ${relative(target, w.dst)}`);
  if (written.length > 20) console.log(`  ... and ${written.length - 20} more`);

  if (flags.dryRun) {
    console.log('\n(dry-run: no files written)');
    return;
  }

  // git init + first commit
  try {
    execSync('git rev-parse --git-dir', { cwd: target, stdio: 'ignore' });
    console.log('\n(skipping git init: already a git repo)');
  } catch {
    try {
      execSync('git init -q', { cwd: target });
      execSync('git add .', { cwd: target });
      const hasInterview = Boolean(vars.COMPANY && vars.PRODUCT);
      const subject = hasInterview
        ? `chore(init): scaffold recruit-kit for ${vars.COMPANY} — ${vars.PRODUCT}`
        : `chore(init): scaffold recruit-kit (placeholders pending interview)`;
      execSync(`git commit -q -m "${subject.replace(/"/g, '\\"')}"`, { cwd: target });
      console.log(`\ngit: initialized + first commit ("${subject}")`);
    } catch (e) {
      console.warn(`\n(git init/commit skipped: ${e.message})`);
    }
  }

  console.log('\n=== next steps ===');
  console.log('1. docs/SPEC.md 의 <!-- SPEC PASTE START --> 영역에 회사 원본 명세 paste');
  console.log('2. docs/PLAN.md 의 §2 "우리의 기획적 해석" 채우기');
  console.log('3. docs/DESIGN.md 의 ADR 5-10개 작성');
  console.log('4. /dod-check 슬래시 커맨드로 게이트 점검');
  console.log('5. 작업 시작 — 매 커밋 시 [§N] 태그 + 사용자 승인\n');
}

main().catch(err => {
  console.error('error:', err);
  process.exit(1);
});
