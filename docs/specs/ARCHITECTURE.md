# Architecture

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | 2026-04-17 |
| last-audited | 2026-04-18 |
| inferred-from | METHODOLOGY.md, ss-initialize/SKILL.md, ss-audit/SKILL.md, ss-fix/SKILL.md, ss-fix/spec/SKILL.md, ss-decision/SKILL.md, README.md, load_claude_skills.sh, repo layout |

## System Overview <!-- required -->

shipspec is a flat, documentation-only repository. It has no runtime and no build. The "system" is a set of Markdown documents that fall into two categories:

1. **The methodology** — one top-level `METHODOLOGY.md` that defines the vocabulary, document hierarchy, workflow paths, and status vocabulary that every skill and every downstream project must conform to.
2. **The skill bundle** — one directory per skill, each containing a single `SKILL.md`. Each skill is a self-contained instruction set that an external AI agent harness (Claude Code) loads and executes against a target project's repository.

Flow at runtime: a developer invokes a skill (e.g. `/ss-audit`) inside their target project. The agent harness loads the corresponding `SKILL.md` from the user's local skills directory, the agent follows its steps, and writes Markdown artifacts into the target project's `docs/specs/` (or `bugs/`, or `docs/maintenance/`) directory. This repo is the source of instructions; the artifacts live in the consumer's repo.

## Component Map <!-- required -->

| Component | Path | Responsibility |
|---|---|---|
| Methodology | `METHODOLOGY.md` | Canonical vocabulary, hierarchy, workflow paths, statuses. Every skill must conform to this. |
| Skill: ss-initialize | `ss-initialize/SKILL.md` | Scaffold OVERVIEW/ARCHITECTURE/ROADMAP for a new project. |
| Skill: ss-audit | `ss-audit/SKILL.md` | Reverse-engineer the same three docs for an existing project, status `inferred`, with an Audit Notes section. |
| Skill: ss-spec | `ss-fix/spec/SKILL.md` | Draft a feature `spec.md` for a planned roadmap item. Nested under `ss-fix/` (see Open Decisions). |
| Skill: ss-fix | `ss-fix/SKILL.md` | Investigate and record a confirmed bug. Produces `bugs/{NNN}-{description}.md`. |
| Skill: ss-decision | `ss-decision/SKILL.md` | Draft a decision record for a completed feature. Produces per-feature `decision.md`. |
| Distribution: gh CLI | external | `gh skill install adrianmoses/shipspec --agent claude-code --scope {user,project}` (gh 2.90.0+). |
| Distribution: loader | `load_claude_skills.sh` | Copies every top-level `*/SKILL.md` directory into `~/.claude/skills/`. Does not recurse, so `ss-fix/spec/` is not picked up. |

There is no shared library, no template directory, and no cross-skill include mechanism. Each skill inlines its own templates verbatim. This is a deliberate duplication: agents load one skill at a time and the skill must be self-contained.

## Data Flow <!-- required -->

Target project is new:

```
developer brief
  → ss-initialize (skill)
    → docs/specs/OVERVIEW.md      (status: draft)
    → docs/specs/ARCHITECTURE.md  (status: draft)
    → docs/specs/ROADMAP.md       (status: draft)

per feature:
  → ss-spec (skill)
    → docs/specs/{NNN}-{feature}/spec.md  (status: draft → approved)
  → [ss-implement skill — NOT YET IMPLEMENTED]
  → ss-decision (skill)
    → docs/specs/{NNN}-{feature}/decision.md  (status: implemented)
```

Target project is existing:

```
codebase + README + deps + tests
  → ss-audit (skill)
    → docs/specs/OVERVIEW.md      (status: inferred, + Audit Notes)
    → docs/specs/ARCHITECTURE.md  (status: inferred)
    → docs/specs/ROADMAP.md       (status: inferred, features marked implemented/in-progress)

human review
  → status: approved
```

Bug fix path:

```
bug report or discovery
  → ss-fix (skill)
    → reproduce, find root cause, write failing test, apply fix
    → bugs/{NNN}-{description}.md  (status: fixed)
```

Inputs flow one direction: methodology → skill → target project artifact. Nothing in this repo reads the artifacts it produces; downstream tooling (other skills) would.

## External Dependencies <!-- required -->

- **AI agent harness.** The skills assume Claude Code (or a compatible host) that can read Markdown instructions, invoke tools (file read/write, grep, shell), and follow structured steps. Skill install targets `~/.claude/skills/`.
- **GitHub CLI (optional).** `gh` version 2.90.0 or later is required for `gh skill install`. Users who do not have it can clone the repo and run `load_claude_skills.sh`.
- **Target project repository.** All artifacts are written to a separate consumer repo. This bundle never writes to itself in normal operation (except audits of itself).
- **No third-party services, APIs, runtime libraries, or network calls.** Pure text.

## Key Constraints <!-- required -->

- **Markdown-only.** All instructions and all outputs are `.md`. No YAML schemas, no JSON, no executable validators.
- **Agent-legible formatting is load-bearing.** Section headers (`## Product Summary`), HTML-comment markers (`<!-- required -->`), and template fences are part of the contract. Renaming a header silently breaks downstream skills that look for it.
- **Self-contained skills.** Each `SKILL.md` inlines its own templates. A skill cannot assume another skill's template is available at runtime.
- **Stable IDs, unstable names.** Per METHODOLOGY.md, feature directories use `{NNN}-{feature-name}`; the numeric prefix is the stable identifier, the slug is a human hint. Any tool that joins across specs must key on `NNN`, not the slug.
- **Status vocabulary is closed.** Valid statuses are enumerated in METHODOLOGY.md (`draft`, `approved`, `inferred`, `implemented`, `superseded`, `deprecated`). Skills must not invent new values.
- **No enforcement layer.** Nothing in the repo verifies that a produced document actually has the required sections. Conformance is currently trust-based.
- **`ss-*` prefix is the invocation contract.** Every skill header is `# Skill: ss-{name}` and the corresponding slash command is `/ss-{name}`. Renaming a skill means updating the header, cross-references in sibling skills, and the README in lockstep.

## Open Decisions <!-- optional -->

- Filename casing for repo-level docs (`00-overview.md` vs `OVERVIEW.md`) — methodology and skills still disagree. See OVERVIEW.md Audit Notes.
- `ss-spec` currently lives nested at `ss-fix/spec/SKILL.md`. Two options: (a) promote to a top-level `ss-spec/` directory (simplest; `load_claude_skills.sh` already handles top-level dirs), or (b) teach the loader to recurse and document the rationale for the nesting. No consumer-visible reason exists today for the nesting.
- Whether METHODOLOGY.md should be updated to reflect the `ss-*` prefix, or whether the skills should drop the prefix. The prefix is valuable as a slash-command namespace but creates a gap with the methodology's plain names.
- Whether a conformance/validation layer is in scope. Without one, METHODOLOGY.md's "test evidence is load-bearing" is unenforceable for the skills themselves.
