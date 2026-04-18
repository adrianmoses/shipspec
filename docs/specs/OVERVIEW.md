# Overview

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | 2026-04-17 |
| last-audited | 2026-04-18 |
| inferred-from | METHODOLOGY.md, ss-initialize/SKILL.md, ss-audit/SKILL.md, ss-fix/SKILL.md, ss-fix/spec/SKILL.md, ss-decision/SKILL.md, README.md, load_claude_skills.sh, git log |

## Product Summary <!-- required -->

shipspec is a spec-driven development methodology and skill bundle for AI coding agents. It defines a document hierarchy (repo-level overview/architecture/roadmap, per-feature spec + decision pairs, bug fix records, maintenance records) and ships a set of Claude Code–style skills (`SKILL.md` files) that agents invoke to scaffold, audit, execute against, and record work in that hierarchy. The core premise: specs are contracts written before implementation, decision records are honest accounts written after, and every operation produces an artifact.

## Target Consumer <!-- required -->

Primary: **AI coding agents** (Claude Code and peers) executing development work against a repository. The skills are written as agent-readable instructions with stable section headers, required/optional markers, and constrained templates so agents produce conforming output.

Secondary: **Developers** who supervise those agents and who author the specs, approve transitions, and fill in the `[YOUR INPUT NEEDED]` fields in decision records.

## Job To Be Done <!-- required -->

Give an AI agent a legible, load-bearing contract before it writes code, and a structured way to record what it actually did after. Close the gap between "what the agent was told to build" and "what got built" so the next agent (or human) can pick up safely.

## Non-Goals <!-- required -->

- Not a runtime, framework, or library. No executable code ships in this repo.
- Not a project-management tool — roadmap status is lightweight, not a replacement for issue trackers.
- Not opinionated about language, framework, or test runner of the downstream project. Those are captured per-project in the generated OVERVIEW.
- Not a packaged distribution on npm/PyPI. Distribution is via `gh skill install` (GitHub CLI 2.90.0+) or the bundled `load_claude_skills.sh` loader.

## Tech Stack <!-- required -->

- **Format:** Markdown only. Every artifact in this repo and every artifact the skills produce is `.md`.
- **Skill format:** Plain `SKILL.md` files, one per skill directory. All current skills use the `# Skill: {name}` header convention; none use YAML frontmatter.
- **Distribution:** `gh skill install adrianmoses/shipspec --agent claude-code --scope user` (primary), or `./load_claude_skills.sh` which copies every top-level `*/SKILL.md` directory into `~/.claude/skills/`.
- **Runtime:** None. Skills are instructions executed by an external AI agent harness (Claude Code).
- **Dependencies:** None. No package manifest (`package.json`, `pyproject.toml`, etc.) present.
- **CI / build:** None present.

## Testing Suite <!-- required -->

No automated tests exist in this repo. There is no test directory, test runner config, or CI configuration. Verification of skill correctness currently relies on a human running the skill against a project and judging the output. If test evidence is expected to be load-bearing per METHODOLOGY.md §Testing, a conformance harness for the skills themselves does not yet exist and remains a roadmap gap.

## Open Questions <!-- optional -->

- Is shipspec intended to be a packaged/versioned product, or a reference implementation others fork? (`gh skill install` leans toward the former.)
- Should the skills themselves follow shipspec (i.e. does this repo eat its own dog food with per-feature specs and decision records under `docs/specs/{NNN}-{feature}/`)? Still unanswered — only the three repo-level docs exist.

## Audit Notes <!-- inferred only -->

### Capabilities Observed

- **Methodology doc** (`METHODOLOGY.md`): defines core philosophy, document hierarchy, four primary workflow paths (new/existing × feature/bug), utility operations, spec statuses, required/optional section markers, decision record discipline, and testing posture.
- **Skill: ss-initialize**: scaffolds three repo-level docs (`OVERVIEW.md`, `ARCHITECTURE.md`, `ROADMAP.md`) for a new project from a product description + tech stack + testing approach.
- **Skill: ss-audit**: reverse-engineers the same three docs for an existing project by reading code, marks status `inferred`, and appends an Audit Notes section. (This skill is what produced the document you are reading.)
- **Skill: ss-spec**: drafts a feature spec for a planned roadmap item. Currently lives nested at `ss-fix/spec/SKILL.md`.
- **Skill: ss-fix**: generates a bug fix record combining investigation, scoping, and fix in one artifact. Writes to `bugs/{NNN}-{description}.md`.
- **Skill: ss-decision**: drafts a decision record for a completed feature. Writes per-feature `decision.md` alongside the feature's `spec.md`, aligned with METHODOLOGY.md.
- **Distribution:** `gh skill install adrianmoses/shipspec --agent claude-code --scope user` (gh 2.90.0+) installs skills interactively; `load_claude_skills.sh` is the fallback.

### Gaps and Inconsistencies

- **Filename convention mismatch.** `METHODOLOGY.md` §Document Hierarchy lists repo-level docs as `00-overview.md`, `01-architecture.md`, `02-roadmap.md` (numeric prefix, lowercase). The `ss-initialize` and `ss-audit` skills create `OVERVIEW.md`, `ARCHITECTURE.md`, `ROADMAP.md` (no prefix, uppercase). Still unresolved — pick one and align all three.
- **Skill name mismatch with methodology vocabulary.** METHODOLOGY.md references skills named `initialize`, `audit`, `fix`, `implement`, `revise-roadmap`, `revise-architecture`, `refactor`, `deprecate-feature`. The repo prefixes every skill with `ss-` (`ss-initialize`, `ss-audit`, `ss-fix`, `ss-spec`, `ss-decision`). The prefix is intentional shorthand for slash-command invocation; METHODOLOGY.md has not yet been updated to reflect it.
- **Missing skills.** Of the workflow paths described in METHODOLOGY.md, the following still have no implementation: `implement` (core — executes a feature spec), `revise-roadmap`, `revise-architecture`, `refactor`, `deprecate-feature`.
- **Nested skill layout.** `ss-spec` is located at `ss-fix/spec/SKILL.md` rather than at a top-level `ss-spec/`. `load_claude_skills.sh` only picks up top-level `*/SKILL.md` directories, so `ss-spec` is not installed by the loader. Either promote it to top-level or teach the loader to recurse.
- **No tests or conformance checks.** METHODOLOGY.md §Testing says "spec compliance is verified by tests, not by agent self-report," but the skills that produce specs have no harness that verifies they produced a conforming artifact. No schema or validator for the document templates exists.
- **This repo does not fully apply its own methodology.** Only the three repo-level docs exist under `docs/specs/`. No per-feature spec/decision pairs, no bug fix records, no maintenance records.

### Uncertain Areas

- Whether the nested `ss-fix/spec/` layout is intentional (e.g. "spec" is conceptually subordinate to a bug/feature entrypoint) or a holdover to be flattened.
- Whether METHODOLOGY.md should be revised to document the `ss-*` naming convention, or whether the skills should drop the prefix in favor of the plain methodology names.
- Whether the target harness is Claude Code specifically. The `gh skill install --agent claude-code` flag and the `load_claude_skills.sh → ~/.claude/skills/` path both point to Claude Code, but nothing in `METHODOLOGY.md` pins it.

### Resolved Since 2026-04-17 Audit

- Skill rename from `shipspec-start`/`shipspec-audit`/`adr-generation` → `ss-initialize`/`ss-audit`/`ss-decision`. The `ss-*` prefix is the canonical shorthand going forward.
- `adr-generation` retired in favor of `ss-decision`, which produces per-feature `decision.md` aligned with METHODOLOGY.md (no more `DECISIONS.md`).
- `ss-fix` skill (plus nested `ss-spec`) added, closing the bug-fix and feature-spec gaps from the prior audit.
- Frontmatter inconsistency resolved by dropping YAML frontmatter everywhere; all skills now use the `# Skill: {name}` header.
- Distribution mechanism settled on `gh skill install` with `load_claude_skills.sh` as fallback.
- `shispec-start` typo removed with the rename.
