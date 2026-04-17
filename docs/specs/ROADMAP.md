# Roadmap

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | 2026-04-17 |
| inferred-from | METHODOLOGY.md, SKILL.md files, git log |

## Features

| ID  | Feature                                            | Status        | Spec |
|-----|----------------------------------------------------|---------------|------|
| 001 | Methodology document (vocabulary, hierarchy, paths, statuses) | implemented   | —    |
| 002 | Skill: shipspec-start — scaffold repo-level docs for new project | implemented   | —    |
| 003 | Skill: shipspec-audit — reverse-engineer repo-level docs for existing project | implemented   | —    |
| 004 | Skill: adr-generation — draft ADRs from spec + plan, emit to DECISIONS.md | implemented   | —    |
| 005 | Skill: implement — execute a feature spec, produce decision.md | planned       | —    |
| 006 | Skill: fix — bug fix path, produce bugs/{id}-{description}.md | planned       | —    |
| 007 | Skill: revise-roadmap — reorder/add/remove features | planned       | —    |
| 008 | Skill: revise-architecture — update ARCHITECTURE when technical decisions drift | planned       | —    |
| 009 | Skill: refactor — structural change, no behavior change, maintenance record | planned       | —    |
| 010 | Skill: deprecate-feature — mark removed, close decision record | planned       | —    |
| 011 | Align filename convention between METHODOLOGY.md and skills (00-overview vs OVERVIEW) | planned       | —    |
| 012 | Rename skills to match METHODOLOGY.md vocabulary (or vice versa) | planned       | —    |
| 013 | Unify skill frontmatter format across all skills | planned       | —    |
| 014 | Reconcile adr-generation with decision.md concept from METHODOLOGY.md | planned       | —    |
| 015 | Conformance/validation harness for produced artifacts | planned       | —    |
| 016 | Apply shipspec to itself (feature specs for this repo's own skills) | in-progress   | —    |

## Status Values

- `planned` — not yet started
- `in-progress` — spec written, implementation underway
- `implemented` — decision record complete
- `deprecated` — removed from product

## Revision History

| Date       | Change |
|------------|--------|
| 2026-04-17 | Initial roadmap inferred by shipspec-audit skill. Items 001–004 marked `implemented` based on code state. Items 005–010 lifted from METHODOLOGY.md references to skills that are named but not present. Items 011–015 lifted from the gaps recorded in OVERVIEW.md Audit Notes. Item 016 captures this audit itself. |

## Inferred-from Notes

- `implemented` status is assigned only to artifacts actually present in the repo. It reflects "exists," not "tested" or "proven correct" — no test suite exists (see OVERVIEW.md Testing Suite).
- `planned` status on items 005–010 is inferred from METHODOLOGY.md §Primary Paths and §Utility Operations, which reference these skills by name. The original commit also contained `comprehension-check/SKILL.md` and `spec-enforcement/SKILL.md`, both deleted in `ca7f91b update skills`; they are **not** listed as `deprecated` here because their roles do not clearly map to any methodology-named skill. Human should decide whether to resurrect, rename, or drop them.
- `in-progress` on item 016 reflects that this very audit is the first application of shipspec to the shipspec repo itself. No feature specs yet exist under `docs/specs/{NNN}-{feature}/`.
