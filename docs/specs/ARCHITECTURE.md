# Architecture

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | 2026-04-17 |
| inferred-from | METHODOLOGY.md, shipspec-start/SKILL.md, shipspec-audit/SKILL.md, adr-generation/SKILL.md, repo layout |

## System Overview <!-- required -->

shipspec is a flat, documentation-only repository. It has no runtime and no build. The "system" is a set of Markdown documents that fall into two categories:

1. **The methodology** — one top-level `METHODOLOGY.md` that defines the vocabulary, document hierarchy, workflow paths, and status vocabulary that every skill and every downstream project must conform to.
2. **The skill bundle** — one directory per skill, each containing a single `SKILL.md`. Each skill is a self-contained instruction set that an external AI agent harness (e.g. Claude Code) loads and executes against a target project's repository.

Flow at runtime: a developer invokes a skill (e.g. `/shipspec-audit`) inside their target project. The agent harness loads the corresponding `SKILL.md` from this bundle, the agent follows its steps, and writes Markdown artifacts into the target project's `docs/specs/` (or `bugs/`, or `docs/maintenance/`) directory. This repo is the source of instructions; the artifacts live in the consumer's repo.

## Component Map <!-- required -->

| Component | Path | Responsibility |
|---|---|---|
| Methodology | `METHODOLOGY.md` | Canonical vocabulary, hierarchy, workflow paths, statuses. Every skill must conform to this. |
| Skill: shipspec-start | `shipspec-start/SKILL.md` | Scaffold OVERVIEW/ARCHITECTURE/ROADMAP for a new project. |
| Skill: shipspec-audit | `shipspec-audit/SKILL.md` | Reverse-engineer the same three docs for an existing project, status `inferred`, with an Audit Notes section. |
| Skill: adr-generation | `adr-generation/SKILL.md` | Draft an ADR from an accepted spec + approved plan, emit to `DECISIONS.md`. Predates the rest of the bundle. |

There is no shared library, no template directory, and no cross-skill include mechanism. Each skill inlines its own templates verbatim. This is a deliberate duplication: agents load one skill at a time and the skill must be self-contained.

## Data Flow <!-- required -->

Target project is new:

```
developer brief
  → shipspec-start (skill)
    → docs/specs/OVERVIEW.md      (status: draft)
    → docs/specs/ARCHITECTURE.md  (status: draft)
    → docs/specs/ROADMAP.md       (status: draft)

per feature:
  → spec.md  (hand-authored or drafted, status: draft → approved)
  → [implement skill — NOT YET IMPLEMENTED]
  → decision.md  (status: implemented)
```

Target project is existing:

```
codebase + README + deps + tests
  → shipspec-audit (skill)
    → docs/specs/OVERVIEW.md      (status: inferred, + Audit Notes)
    → docs/specs/ARCHITECTURE.md  (status: inferred)
    → docs/specs/ROADMAP.md       (status: inferred, features marked implemented/in-progress)

human review
  → status: approved
```

ADR drafting (standalone, predates methodology):

```
spec handoff summary + approved plan
  → adr-generation (skill)
    → ADR draft with [YOUR INPUT NEEDED] blanks
  → developer fills blanks
    → appended to DECISIONS.md
```

Inputs flow one direction: methodology → skill → target project artifact. Nothing in this repo reads the artifacts it produces; downstream tooling (other skills) would.

## External Dependencies <!-- required -->

- **AI agent harness.** The skills assume an executing environment that can read Markdown instructions, invoke tools (file read/write, grep, shell), and follow structured steps. Claude Code is the implied host based on the `SKILL.md` filename convention, but the skills do not name it explicitly.
- **Target project repository.** All artifacts are written to a separate consumer repo. This bundle never writes to itself in normal operation (except this audit).
- **No third-party services, APIs, runtime libraries, or network calls.** Pure text.

## Key Constraints <!-- required -->

- **Markdown-only.** All instructions and all outputs are `.md`. No YAML schemas, no JSON, no executable validators.
- **Agent-legible formatting is load-bearing.** Section headers (`## Product Summary`), HTML-comment markers (`<!-- required -->`), and template fences are part of the contract. Renaming a header silently breaks downstream skills that look for it.
- **Self-contained skills.** Each `SKILL.md` inlines its own templates. A skill cannot assume another skill's template is available at runtime.
- **Stable IDs, unstable names.** Per METHODOLOGY.md, feature directories use `{NNN}-{feature-name}`; the numeric prefix is the stable identifier, the slug is a human hint. Any tool that joins across specs must key on `NNN`, not the slug.
- **Status vocabulary is closed.** Valid statuses are enumerated in METHODOLOGY.md (`draft`, `approved`, `inferred`, `implemented`, `superseded`, `deprecated`). Skills must not invent new values.
- **No enforcement layer.** Nothing in the repo verifies that a produced document actually has the required sections. Conformance is currently trust-based.

## Open Decisions <!-- optional -->

- Filename casing for repo-level docs (`00-overview.md` vs `OVERVIEW.md`) — methodology and skills disagree. See OVERVIEW.md Audit Notes.
- Whether `adr-generation` is part of the canonical path or a legacy skill to be replaced by a `decision.md`-producing skill aligned with METHODOLOGY.md.
- Whether skills should carry YAML frontmatter uniformly (current state: only `adr-generation` does).
- Whether a conformance/validation layer is in scope. Without one, METHODOLOGY.md's "test evidence is load-bearing" is unenforceable for the skills themselves.
