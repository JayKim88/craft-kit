# Recommended Tools

> External tools that integrate with craft-kit.
> **Not included in the kit** — install once per developer machine, not per project.

---

## context-mode

**Role**: MCP server that reduces AI context token consumption by ~98% during long sessions.

**Problem it solves**: Phase C implementation cycles can run 30–60 iterations. Without context management, file reads and procedure docs accumulate in the AI context window, triggering compaction and cutting sessions short. context-mode sandboxes tool output and returns summaries instead of raw content.

**How it works**:
- File reads, code execution, and web fetches run in isolated subprocesses — only stdout enters context
- `ctx_index` chunks files into a local FTS5 SQLite database
- `ctx_search` retrieves only the relevant sections via BM25 ranking
- Session state (edits, git ops, errors) persists in DB — recoverable after compaction

**Required** for all projects. Install once per machine.

**Install (Claude Code):**
```
/plugin marketplace add mksglu/context-mode
/plugin install context-mode@context-mode
/context-mode:ctx-doctor
```

**Use after install (Phase B):**
```
ctx_index docs/
```
Indexes all kit procedure docs. During Phase C, the AI can `ctx_search` instead of reloading full procedure files each turn.

**Primary tools:**

| Tool | Use |
|------|-----|
| `ctx_execute` | Run a script; only stdout enters context (e.g. count functions, lint output) |
| `ctx_index` | Chunk a file or directory into the searchable DB |
| `ctx_search` | Query indexed content by keyword |
| `ctx_fetch_and_index` | Fetch a URL, convert to markdown, index it |

---

## code-review-graph

**Role**: MCP server that builds a dependency knowledge graph of the codebase. Used in Procedure 8 to compute blast-radius before a code review — so the AI reads only files actually affected by a change.

**Problem it solves**: Without it, `proc-8-code-review.md` relies on `git diff HEAD` as the review scope. For medium/large projects this can mean reading dozens of files when only a handful are relevant. code-review-graph uses BFS over the dependency graph to narrow the scope.

**How it works**:
- Tree-sitter parses the codebase into AST (24+ languages supported)
- Nodes (File, Class, Function, Type, Test) + Edges (CALLS, IMPORTS_FROM, INHERITS, TESTED_BY, …) stored in SQLite
- BFS from changed files → returns all transitively affected files
- Git hook triggers incremental re-parse on file change (<2 seconds typical)
- Exposes 28 MCP tools to Claude Code

**Install (once per machine):**
```bash
pip install code-review-graph
code-review-graph install   # auto-registers MCP into Claude Code / Cursor / etc.
```

**Use at Phase B (per project):**
```bash
code-review-graph build     # parse project once — creates .code-review-graph/ dir
code-review-graph watch     # background daemon; incremental updates on save
```

> **Required for projects with source code** (`src/` exists). Skip only for kit-only work (docs + scripts, no `src/`).

**Does NOT need to be added to the project repo** — add `.code-review-graph/` to `.gitignore` manually. Runs as a global MCP server pointed at the current project directory.
