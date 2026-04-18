# Roadmap

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | 2026-04-17 |
| last-audited | 2026-04-18 |
| inferred-from | METHODOLOGY.md, SKILL.md files, README.md, load_claude_skills.sh, git log |

## Features

| ID  | Feature                                            | Status        | Spec |
|-----|----------------------------------------------------|---------------|------|
| 001 | Methodology document (vocabulary, hierarchy, paths, statuses) | implemented   | —    |
| 002 | Skill: ss-initialize — scaffold repo-level docs for new project | implemented   | —    |
| 003 | Skill: ss-audit — reverse-engineer repo-level docs for existing project | implemented   | —    |
| 004 | Skill: ss-decision — per-feature decision record after implementation | implemented   | —    |
| 005 | Skill: ss-implement — execute a feature spec end-to-end | planned       | —    |
| 006 | Skill: ss-fix — bug fix path, produce bugs/{id}-{description}.md | implemented   | —    |
| 007 | Skill: ss-spec — draft a feature spec for a planned roadmap item | implemented   | —    |
| 008 | Skill: ss-revise-roadmap — reorder/add/remove features | planned       | —    |
| 009 | Skill: ss-revise-architecture — update ARCHITECTURE when technical decisions drift | planned       | —    |
| 010 | Skill: ss-refactor — structural change, no behavior change, maintenance record | planned       | —    |
| 011 | Skill: ss-deprecate-feature — mark removed, close decision record | planned       | —    |
| 012 | Align filename convention between METHODOLOGY.md and skills (00-overview vs OVERVIEW) | planned       | —    |
| 013 | Reconcile `ss-*` skill prefix with METHODOLOGY.md vocabulary | planned       | —    |
| 014 | Promote `ss-spec` out of the nested `ss-fix/spec/` location (or make loader recurse) | planned       | —    |
| 015 | Unify skill frontmatter format across all skills | implemented   | —    |
| 016 | Reconcile adr-generation with decision.md concept from METHODOLOGY.md | implemented   | —    |
| 017 | Conformance/validation harness for produced artifacts | planned       | —    |
| 018 | Distribution via `gh skill install` (gh 2.90.0+) and documented fallback loader | implemented   | —    |
| 019 | Apply shipspec to itself (feature specs for this repo's own skills) | in-progress   | —    |

## Status Values

- `planned` — not yet started
- `in-progress` — spec written, implementation underway
- `implemented` — decision record complete
- `deprecated` — removed from product

## Revision History

| Date       | Change |
|------------|--------|
| 2026-04-17 | Initial roadmap inferred by `ss-audit`. Items 001–004 marked `implemented` based on code state. Items 005–010 lifted from METHODOLOGY.md references to skills that are named but not present. Items 011–015 lifted from the gaps recorded in OVERVIEW.md Audit Notes. Item 016 captured this audit itself. |
| 2026-04-18 | Re-audit after skill rename (`shipspec-*`/`adr-generation` → `ss-*`). Items 002/003/004 renamed in place. Item 006 (`ss-fix`) flipped `planned` → `implemented`. Item 007 added for `ss-spec` (implemented but nested). Items 011/012/013/014 renumbered and split: filename convention (012) still open; `ss-*` vs methodology vocabulary (013) newly opened; nested `ss-spec` location (014) newly opened. Item 015 (frontmatter) flipped `planned` → `implemented` (resolved by dropping frontmatter). Item 016 (adr-generation reconciliation) flipped `planned` → `implemented` via `ss-decision`. Item 017 is the renumbered conformance harness. Item 018 added for the `gh skill install` distribution path. Item 019 is the renumbered "apply shipspec to itself" item, still `in-progress`. |

## Inferred-from Notes

- `implemented` status is assigned only to artifacts actually present in the repo. It reflects "exists," not "tested" or "proven correct" — no test suite exists (see OVERVIEW.md Testing Suite).
- `planned` status on items 005, 008–011 is inferred from METHODOLOGY.md §Primary Paths and §Utility Operations, which reference these skills by name. The `ss-` prefix on their planned names is a projection of the current naming convention.
- `in-progress` on item 019 reflects that the shipspec repo still has only the three repo-level docs under `docs/specs/`. No per-feature specs or decision records exist yet.
- Items 015 and 016 are marked `implemented` without a dedicated decision record — they were resolved by incidental changes (dropping frontmatter, renaming `adr-generation` to `ss-decision`) rather than a planned feature cycle. This is itself a gap worth noting: the repo's own changes are not being captured as decision records.
