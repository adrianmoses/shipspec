# shipspec

A spec-driven development workflow for building software with AI coding agents.

shipspec is a methodology plus a set of skills that AI agents invoke to scaffold, audit, execute against, and record development work. Specs are written before implementation as contracts. Decision records are written after as honest accounts of what was built. The gap between the two is where learning lives.

Start with [`METHODOLOGY.md`](./METHODOLOGY.md) for the full vocabulary, document hierarchy, and workflow paths.

---

## What's in this repo

```
METHODOLOGY.md           ← the canonical methodology
ss-initialize/SKILL.md   ← scaffold repo-level docs for a new project
ss-audit/SKILL.md        ← reverse-engineer repo-level docs for an existing project
ss-fix/SKILL.md          ← investigate and record a bug fix
ss-spec/SKILL.md         ← write a feature spec for a planned roadmap item
ss-plan/SKILL.md         ← produce an implementation plan against an approved spec
ss-decision/SKILL.md     ← draft a decision record for a completed feature
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
| New project, new feature | `ss-initialize` → spec.md → `ss-plan` → implement → decision.md |
| Existing project, new feature | `ss-audit` → spec.md → `ss-plan` → implement → decision.md |
| Bug fix | (`ss-audit`?) → fix → `bugs/{id}-{description}.md` |

---

## Using the skills

The skills in this repo follow the Claude Code `SKILL.md` convention.

### Install with the GitHub CLI (recommended)

Requires `gh` version 2.90.0 or later. Install all skills into your user-scope Claude Code skills directory interactively — `gh` will prompt you to pick which skills to install:

```
gh skill install adrianmoses/shipspec --agent claude-code --scope user
```

Other useful variants:

```
# Project scope (installs into ./.claude/skills/ in the current repo)
gh skill install adrianmoses/shipspec --agent claude-code --scope project

# Pin to a specific ref (tag, branch, or commit)
gh skill install adrianmoses/shipspec@main --agent claude-code --scope user
```

### Install with the bundled script

Alternatively, clone this repo and run the loader to copy every skill into `~/.claude/skills/`:

```
./load_claude_skills.sh
```

### Invoking the skills

Once installed, invoke them from your target project:

```
/ss-initialize       # new project
/ss-audit            # existing project with no docs/specs/
/ss-fix              # bug fix
/ss-spec             # feature spec for a planned roadmap item
/ss-plan             # implementation plan against an approved spec
/ss-decision         # decision record after implementation
```

Each skill is self-contained — it inlines its own templates and does not depend on another skill being loaded.

---

## Status

shipspec is early and actively evolving. See [`docs/specs/ROADMAP.md`](./docs/specs/ROADMAP.md) for what exists, what's planned, and the known gaps between `METHODOLOGY.md` and the shipped skills.
