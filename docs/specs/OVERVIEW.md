# Overview

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | 2026-04-17 |
| inferred-from | METHODOLOGY.md, shipspec-start/SKILL.md, shipspec-audit/SKILL.md, adr-generation/SKILL.md, git log |

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
- Not intended to be consumed as a packaged distribution (npm, PyPI, etc.); current distribution model appears to be "copy the skill files into your agent's skills directory."

## Tech Stack <!-- required -->

- **Format:** Markdown only. Every artifact in this repo and every artifact the skills produce is `.md`.
- **Skill format:** Plain `SKILL.md` files, one per skill directory. One skill (`adr-generation`) uses YAML frontmatter with `name` and `description`; the other two do not. See Audit Notes.
- **Runtime:** None. Skills are instructions executed by an external AI agent harness (e.g. Claude Code).
- **Dependencies:** None. No package manifest (`package.json`, `pyproject.toml`, etc.) present.
- **CI / build:** None present.

## Testing Suite <!-- required -->

No automated tests exist in this repo. There is no test directory, test runner config, or CI configuration. Verification of skill correctness currently relies on a human running the skill against a project and judging the output. If test evidence is expected to be load-bearing per METHODOLOGY.md §Testing, a conformance harness for the skills themselves does not yet exist and may be a roadmap gap.

## Open Questions <!-- optional -->

- Is shipspec intended to be a packaged/versioned product, or a reference implementation others fork?
- Should the skills themselves follow shipspec (i.e. does this repo eat its own dog food with specs and decision records under `docs/specs/`)? This audit is a first step in that direction.

## Audit Notes <!-- inferred only -->

### Capabilities Observed

- **Methodology doc** (`METHODOLOGY.md`): defines core philosophy, document hierarchy, four primary workflow paths (new/existing × feature/bug), utility operations, spec statuses, required/optional section markers, decision record discipline, and testing posture.
- **Skill: shipspec-start**: scaffolds three repo-level docs (`OVERVIEW.md`, `ARCHITECTURE.md`, `ROADMAP.md`) for a new project from a product description + tech stack + testing approach.
- **Skill: shipspec-audit**: reverse-engineers the same three docs for an existing project by reading code, marks status `inferred`, and appends an Audit Notes section. (This skill is what produced the document you are reading.)
- **Skill: adr-generation**: drafts an Architecture Decision Record from an accepted spec and approved plan, leaving `[YOUR INPUT NEEDED]` blanks for developer-only fields (alternatives, tradeoffs, consequences), and outputs to `DECISIONS.md`.

### Gaps and Inconsistencies

- **Filename convention mismatch.** `METHODOLOGY.md` §Document Hierarchy lists repo-level docs as `00-overview.md`, `01-architecture.md`, `02-roadmap.md` (numeric prefix, lowercase). The `shipspec-start` and `shipspec-audit` skills create `OVERVIEW.md`, `ARCHITECTURE.md`, `ROADMAP.md` (no prefix, uppercase). `shipspec-audit/SKILL.md` further refers back to `00-overview.md` in its Audit Notes instructions. Pick one and align all three.
- **Skill name mismatch.** METHODOLOGY.md references skills named `initialize`, `audit`, `fix`, `implement`, `revise-roadmap`, `revise-architecture`, `refactor`, `deprecate-feature`. The repo contains `shipspec-start`, `shipspec-audit`, `adr-generation`. Only two of the referenced skills have a corresponding implementation, and under different names.
- **Missing skills.** Of the workflow paths described in METHODOLOGY.md, the following have no implementation: `implement` (core — executes a feature spec), `fix` (core — bug fix path), `revise-roadmap`, `revise-architecture`, `refactor`, `deprecate-feature`. The only two concrete skills that ship are the two scaffolding skills (start/audit) plus ADR drafting.
- **adr-generation predates the methodology.** It produces entries appended to `DECISIONS.md`, not per-feature `decision.md` files under `docs/specs/{NNN}-{feature}/`. Its terminology ("ADR", "spec-enforcement skill", "plan") does not align with the methodology's terminology ("spec", "decision record"). Either the methodology's `decision.md` step needs a dedicated skill, or `adr-generation` needs to be refactored to fit.
- **Removed skills.** `git log` shows that `comprehension-check/SKILL.md` and `spec-enforcement/SKILL.md` existed in the initial commit and were deleted in `ca7f91b update skills`. `adr-generation/SKILL.md` still references "the spec-enforcement skill" as an upstream input, which is now a dangling reference.
- **Frontmatter inconsistency.** `adr-generation/SKILL.md` has YAML frontmatter with `name:` and `description:`. `shipspec-start/SKILL.md` and `shipspec-audit/SKILL.md` do not. If the agent harness uses frontmatter for skill discovery/triggering, the two newer skills may not be discoverable the same way.
- **Typo.** `shipspec-start/SKILL.md` line 1: `# Skill: shispec-start` (missing `p` in "shipspec").
- **No tests or conformance checks.** METHODOLOGY.md §Testing says "spec compliance is verified by tests, not by agent self-report," but the skills that produce specs have no harness that verifies they produced a conforming artifact. There is no schema or validator for the document templates.
- **`docs/specs/` did not exist before this audit.** The project does not currently apply its own methodology to itself.

### Uncertain Areas

- Intended distribution mechanism (copy/paste, git submodule, npm package, something else).
- Whether the methodology is stable or still in active revision — the second commit heavily reworked the skill set, suggesting the shape is still moving.
- Whether the target harness is Claude Code specifically, or AI coding agents in general. The skill file shape matches Claude Code's `SKILL.md` convention, but nothing in the repo pins this.
- Whether `adr-generation` is deprecated in favor of an as-yet-unwritten `decision.md` skill, or whether both are expected to coexist.
