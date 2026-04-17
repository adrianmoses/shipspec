# shipspec

A spec-driven development workflow for building software with AI coding agents.

shipspec is a methodology plus a set of skills that AI agents invoke to scaffold, audit, execute against, and record development work. Specs are written before implementation as contracts. Decision records are written after as honest accounts of what was built. The gap between the two is where learning lives.

Start with [`METHODOLOGY.md`](./METHODOLOGY.md) for the full vocabulary, document hierarchy, and workflow paths.

---

## What's in this repo

```
METHODOLOGY.md           ← the canonical methodology
shipspec-start/SKILL.md  ← scaffold repo-level docs for a new project
shipspec-audit/SKILL.md  ← reverse-engineer repo-level docs for an existing project
adr-generation/SKILL.md  ← draft an ADR from an accepted spec + approved plan
docs/specs/              ← shipspec applied to itself (inferred)
```

This repo contains no runtime code. Every artifact is Markdown. Skills are instruction sets loaded and executed by an AI agent harness (e.g. Claude Code).

---

## Core philosophy

- **Specs are contracts, not documentation.** A spec written before implementation is a commitment.
- **Consumer first.** Every feature spec names who it is for and the job it does for them.
- **Agents need unambiguous inputs.** Stable section headers, required/optional markers, constrained formats.
- **Every operation produces an artifact.** No codeless spec, no specless code.

---

## Workflow paths

| Situation | Path |
|---|---|
| New project, new feature | `shipspec-start` → spec.md → implement → decision.md |
| Existing project, new feature | `shipspec-audit` → spec.md → implement → decision.md |
| Bug fix | (`shipspec-audit`?) → fix → `bugs/{id}-{description}.md` |

---

## Using the skills

The skills in this repo follow the Claude Code `SKILL.md` convention. To use one, copy the skill directory into your agent's skills path, then invoke it from your target project:

```
/shipspec-start      # new project
/shipspec-audit      # existing project with no docs/specs/
```

Each skill is self-contained — it inlines its own templates and does not depend on another skill being loaded.

---

## Status

shipspec is early and actively evolving. See [`docs/specs/ROADMAP.md`](./docs/specs/ROADMAP.md) for what exists, what's planned, and the known gaps between `METHODOLOGY.md` and the shipped skills.
