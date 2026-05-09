#!/usr/bin/env node
// takehome-kit / init.mjs
// Interview → placeholder substitution → scaffold a take-home assignment workspace.
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

// Auto-fallback to quiet mode when stdin is not a TTY (pipe, CI).
// readline.question() on a closed pipe rejects mid-interview, leaving
// the scaffold half-written. Quiet mode preserves placeholders cleanly.
if (!flags.quiet && !process.stdin.isTTY) {
  console.log('(stdin is not a TTY — auto-switching to --quiet mode. Run interactively from a terminal for the interview.)');
  flags.quiet = true;
}

if (flags.help) {
  console.log(`takehome-kit init — scaffold a take-home assignment workspace.

Usage:
  node bin/init.mjs [target] [options]
  npx degit JayKim88/takehome-kit my-task && node my-task/bin/init.mjs

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
  console.log('\n=== takehome-kit interview ===\n');
  console.log('Answer in English. Press Enter to keep the default.\n');

  const COMPANY = await ask('Company name (COMPANY)', 'AcmeCo');
  const PRODUCT = await ask('Product / assignment name (PRODUCT)', 'Take-Home Assignment');
  const ROLE = await ask('Role (ROLE)', 'Software Engineer');
  const TASK_TYPE = await ask('Assignment type (TASK_TYPE: FE|BE|FS|ML|Mobile|Other)', 'FE');
  const DEADLINE_DATE = await ask('Deadline (DEADLINE_DATE, YYYY-MM-DD)', todayISO());
  if (!/^\d{4}-\d{2}-\d{2}$/.test(DEADLINE_DATE)) {
    console.warn(`⚠ DEADLINE_DATE "${DEADLINE_DATE}" is not in YYYY-MM-DD format. Continuing, but schedule math may be off.`);
  }
  const DEADLINE_TIME = await ask('Deadline time (DEADLINE_TIME)', '23:59');
  const ONELINE_CHALLENGE = await ask('One-line core challenge (ONELINE_CHALLENGE)', 'Core domain logic + state separation');
  const STACK_HINT = await ask('Stack hint (STACK_HINT, free-form)', 'TypeScript + React + Vitest');
  const ENV_NOTES = await ask('Environment notes (ENV_NOTES, leave blank if none)', 'No special concerns (standard environment).');

  console.log('\n--- Run commands (optional — leave blank to keep placeholder) ---');
  const TECH_RUNTIME = await ask('Runtime (TECH_RUNTIME, e.g. Node.js / Python / Java)', '');
  const RUNTIME_VERSION = await ask('Runtime version (RUNTIME_VERSION, e.g. 22.19 / 3.13 / 21)', '');
  const INSTALL_COMMAND = await ask('Install command (INSTALL_COMMAND, e.g. npm install / poetry install)', '');
  const DEV_COMMAND = await ask('Dev server command (DEV_COMMAND, e.g. npm run dev)', '');
  const TEST_COMMAND = await ask('Test command (TEST_COMMAND, e.g. npm test)', '');
  const BUILD_COMMAND = await ask('Build command (BUILD_COMMAND, e.g. npm run build / leave blank if none)', '');

  console.log('\n--- Evaluation criteria ---');
  console.log('Enter N rubric categories from the company spec. (Usually 5-7.)');
  const nStr = await ask('Number of criteria (CRITERIA_COUNT)', '6');
  const n = Math.max(1, parseInt(nStr, 10) || 6);

  const criteria = [];
  for (let i = 1; i <= n; i++) {
    const name = await ask(`§${i} category name (e.g. "Requirements understanding & problem definition")`, `Criterion ${i}`);
    const pts = await ask(`§${i} points (number)`, '20');
    const parsed = parseInt(pts, 10);
    if (Number.isNaN(parsed) || parsed < 0) {
      console.warn(`⚠ §${i} points "${pts}" is not a valid number. Setting to 0.`);
    }
    criteria.push({ index: i, name, points: Number.isNaN(parsed) ? 0 : parsed });
  }
  const totalPoints = criteria.reduce((s, c) => s + c.points, 0);
  console.log(`\nTotal: ${totalPoints} pts (${criteria.length} categories)`);

  console.log('\n--- Criterion-index mapping ---');
  console.log('Tell us which §N each of the four areas below maps to. (Leave blank to fall back to keyword auto-inference.)');
  console.log('Current categories:');
  for (const c of criteria) console.log(`  §${c.index}: ${c.name}`);

  const askIdx = async (label, keywordRegex) => {
    const auto = criteria.findIndex(c => keywordRegex.test(c.name));
    const defaultStr = auto >= 0 ? String(auto + 1) : '';
    const ans = await ask(`Which §N is the "${label}" category? (1-${n}, blank if unsure)`, defaultStr);
    const parsed = parseInt(ans, 10);
    if (Number.isNaN(parsed) || parsed < 1 || parsed > n) {
      return auto >= 0 ? String(auto + 1) : 'N';
    }
    return String(parsed);
  };

  const REQ_CRITERION_INDEX = await askIdx('Requirements understanding', /requirement|understanding|problem/i);
  const DESIGN_CRITERION_INDEX = await askIdx('Design / code structure', /design|structure|architecture|code/i);
  const DOC_CRITERION_INDEX = await askIdx('Documentation', /doc|documentation|writing/i);
  const GIT_CRITERION_INDEX = await askIdx('Git / work trail', /git|commit|work trail|history/i);

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
    EVAL_MAPPING_TABLE: buildMappingTable(criteria),
    DOC_CRITERION_INDEX,
    GIT_CRITERION_INDEX,
    DESIGN_CRITERION_INDEX,
    REQ_CRITERION_INDEX,
    // numeric points P1..P9 (kept for back-compat with templates that still reference them)
    ...Object.fromEntries(criteria.map((c, i) => [`P${i + 1}`, String(c.points)])),
  };
}

function buildMappingTable(criteria) {
  const header = '| Criterion (points) | Where it is satisfied |\n|---|---|';
  const rows = criteria.map(c => `| §${c.index} ${c.name} (${c.points} pts) | <!-- Fill in: which sections of SPEC + PLAN + DESIGN + CHECKLIST contribute to this score --> |`);
  return [header, ...rows].join('\n');
}

function buildCriteriaTable(criteria) {
  return criteria.map(c => {
    return `### ${c.index}) ${c.name} (${c.points} pts)

<!-- HINT: Transcribe the ambiguities / checkpoints for this category from the company spec verbatim. -->

| Checkpoint | Low proficiency | High proficiency |
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
      console.error(`error: target is takehome-kit itself. Use 'npx degit JayKim88/takehome-kit my-task && cd my-task && node bin/init.mjs' instead.`);
      process.exit(1);
    }
    if (!flags.quiet) {
      const proceed = await ask(`target ${target} is not empty. Proceed? (y/N)`, 'N');
      if (proceed.toLowerCase() !== 'y') {
        console.log('Aborted.');
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
        ? `chore(init): scaffold takehome-kit for ${vars.COMPANY} — ${vars.PRODUCT}`
        : `chore(init): scaffold takehome-kit (placeholders pending interview)`;
      execSync(`git commit -q -m "${subject.replace(/"/g, '\\"')}"`, { cwd: target });
      console.log(`\ngit: initialized + first commit ("${subject}")`);
    } catch (e) {
      console.warn(`\n(git init/commit skipped: ${e.message})`);
    }
  }

  console.log('\n=== next steps ===');
  console.log('1. Paste the company spec into the <!-- SPEC PASTE START --> region of docs/SPEC.md');
  console.log('2. Fill docs/PLAN.md §2 "Our planning interpretation"');
  console.log('3. Write 5-10 ADRs in docs/DESIGN.md');
  console.log('4. Run the /dod-check slash command for gate verification');
  console.log('5. Start work — every commit gets a [§N] tag + user approval\n');
}

main().catch(err => {
  console.error('error:', err);
  process.exit(1);
});
