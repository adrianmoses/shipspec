# Skill: ss-audit

Reverse-engineer the spec suite for an existing project by reading the codebase. Output is the same three repo-level docs that `ss-initialize` produces, but with status `inferred`. Once complete, the project is on the canonical shipspec path.

---

## When to Use

- An existing project has no `docs/specs/` directory
- A project was started without shipspec and needs to be brought onto the workflow
- The codebase is not well understood and needs to be documented before a bug fix or new feature

Do not use this skill on new projects. Use the `ss-initialize` skill instead.

---

## Inputs

| Input | Required | Description |
|---|---|---|
| Codebase access | Yes | Ability to read the repository |
| Entry points | No | Known entry points, main files, or README to start from |
| Known constraints | No | Anything the human already knows about the system |

If a README exists, read it first. It is the fastest path to product intent.

---

## Output

Three files created in `docs/specs/`:

```
docs/specs/
  OVERVIEW.md        ← status: inferred
  ARCHITECTURE.md    ← status: inferred
  ROADMAP.md         ← status: inferred
```

---

## Steps

### 1. Discovery Pass

Before writing anything, read the codebase to build a mental model. In order:

1. Read `README.md` if it exists
2. Read any existing docs in `docs/`, `wiki/`, or similar
3. Read the dependency manifest (`package.json`, `Cargo.toml`, `pyproject.toml`, etc.)
4. Identify entry points — `main`, `index`, `app`, `server`, or equivalent
5. Trace the primary data flow from entry point through to output
6. Identify external dependencies and integrations
7. Read the test suite to understand intended behavior — tests are often more honest than docs

Do not begin writing specs until this pass is complete.

---

### 2. Discovery Audit Mode

If the codebase is large or unfamiliar, run a structured discovery audit before writing specs:

**What does this thing actually do?**
- List every distinct capability you can observe from the code
- Note what data enters, what is transformed, what exits
- Identify who or what consumes the output

**Where does it deviate from good practice or its own implicit contract?**
- Inconsistencies between the README and the implementation
- Dead code, unused dependencies, or orphaned modules
- Missing error handling, missing tests, or untested paths
- Hardcoded values that suggest unfinished abstraction

Record findings in a `## Audit Notes` section appended to `OVERVIEW.md`. These are not part of the canonical spec — they are inputs for the human to review.

---

### 3. Run the verification dialogue

The findings from steps 1 and 2 are inferences from code. Before drafting, present them to the human for confirmation, correction, or explicit "leave as uncertain." This is the difference between an audit that captures reality and one that captures the agent's reading of code.

**Frame.** State in one line what is about to happen: *"I've read the codebase and have inferences ready. I'll walk through what I see, you confirm or correct, then I draft the three files."*

**Verify.** Present the prompts below in order, with a hard cap of 5 total. Each prompt is grounded in what was observed during steps 1 and 2 — do not ask open questions; ask the human to confirm, correct, or flag as still-uncertain. Fill in `{list}` / `{X}` from your observations before asking.

1. **Capabilities.** Top capabilities seen from the code: `{list}`. Did I miss any? Are any of these actually deprecated or dead code?
2. **Consumer.** Inferred consumer: `{X}` (based on `{API surface | UI | CLI | integration points}`). Right person? Other consumers — internal teams, downstream systems, agents — that the code doesn't make obvious?
3. **Implicit non-goals.** Things this codebase does *not* do that I might have expected: `{list}`. Intentional non-goals, or accidental gaps?
4. **Uncertain inferences.** Things I could not determine from code alone: `{list}`. Resolve any of these now, or leave as `[INFERRED: uncertain — please verify]`?
5. **Tech stack and testing accuracy.** Tech stack from manifests: `{list}`. Anything missing, misleading, or planned to be removed? Test rigor observed: `{summary}` — does that reflect the team's actual posture, or is the test suite under-built?

If the answer to any prompt is already obvious from a README, ADR, or earlier conversation context, do not ask — surface the inferred answer in the reflect-back instead.

**Reflect.** Present a single batched summary in the shape of the three documents. Use three states explicitly: `✓` confirmed by the human, `•` inferred from code (acceptable), `?` uncertain (will be marked `[INFERRED: uncertain — please verify]` in the doc):

```
Here's what I'm about to write (✓ confirmed, • inferred from code, ? uncertain):

OVERVIEW
- Product summary:  • from README + entry points
- Consumer:         ✓ {…}
- Job to be done:   • from primary capability
- Non-goals:        ✓ {…}
- Tech stack:       • from {manifest}
- Testing suite:    • from {test dir + CI config}
- Audit notes:
  - Capabilities:         ✓ {N} confirmed
  - Gaps/inconsistencies: • {list}
  - Uncertain areas:      ? {list}

ARCHITECTURE
- System overview:  • from entry points
- Component map:    • from directory structure
- Data flow:        • traced main path
- External deps:    • from manifest + observed calls
- Key constraints:  ? could not determine

ROADMAP
- Features: • {N} capabilities → `implemented` entries

Anything to correct, or leave as inferred for now?
```

Wait for explicit approval or correction before drafting. Items still marked `?` after the dialogue carry forward into the docs as `[INFERRED: uncertain — please verify]` — they are not failures, they are honest signals to the human about where the audit ran out of evidence.

### 4. Draft the three docs

Render the templates below in order: `OVERVIEW.md`, `ARCHITECTURE.md`, then `ROADMAP.md`. Every section must trace back to either an observation from steps 1–2, a confirmation from step 3, or an explicit `[INFERRED: uncertain — please verify]` flag. Do not introduce new claims at draft time that were not surfaced during dialogue.

### 5. Hand off for review

Present the three drafted files. The human's job from here is to resolve remaining `[INFERRED: uncertain]` flags and decide whether status moves from `inferred` to `approved`, or whether observed gaps warrant follow-up bug fixes or feature specs.

### Opt-out: quick mode

If the human invokes the skill with `--quick`, or asks to "just write what you see," skip step 3's dialogue entirely. Draft directly from the code-reading passes, and surface uncertain items aggressively as `[INFERRED: uncertain — please verify]`. This is roughly the historical default for `ss-audit` — the verification dialogue is the upgrade. Quick mode is the right call when the human plans to do their own pass over the drafts.

---

## Templates

### OVERVIEW.md

Infer as much as possible from the codebase. Where intent cannot be determined from code, mark the field with `[INFERRED: uncertain — please verify]`.

```markdown
# Overview

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | {date} |
| inferred-from | {list of key files read} |

## Product Summary <!-- required -->

{Inferred from README, entry points, and primary data flow.}

## Target Consumer <!-- required -->

{Inferred from API surface, UI, CLI interface, or integration points.}

## Job To Be Done <!-- required -->

{Inferred from the primary capability of the system.}

## Non-Goals <!-- required -->

{Inferred from what the system explicitly does not handle, or marked uncertain.}

## Tech Stack <!-- required -->

{Extracted from dependency manifests and entry points.}

## Testing Suite <!-- required -->

{Extracted from test directories, test runner config, and CI config.}

## Audit Notes <!-- inferred only -->

### Capabilities Observed
{Bullet list of distinct things the system does.}

### Gaps and Inconsistencies
{Bullet list of deviations, dead code, missing tests, or implicit contracts not honored.}

### Uncertain Areas
{Bullet list of things that could not be determined from the code alone.}
```

---

### ARCHITECTURE.md

```markdown
# Architecture

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | {date} |
| inferred-from | {list of key files read} |

## System Overview <!-- required -->

{Inferred from entry points and component structure.}

## Component Map <!-- required -->

{Inferred from directory structure, module boundaries, and import graph.}

## Data Flow <!-- required -->

{Traced from entry point through primary path to output.}

## External Dependencies <!-- required -->

{Extracted from dependency manifests and network calls observed in code.}

## Key Constraints <!-- required -->

{Inferred from configuration, environment variables, and hardcoded limits.}
```

---

### ROADMAP.md

Infer features from the codebase. Each distinct capability observed in the discovery pass becomes a roadmap entry marked `implemented`. Unknown or partially implemented features are marked `in-progress`.

```markdown
# Roadmap

<!-- status: inferred -->
| Field | Value |
|---|---|
| status | inferred |
| created | {date} |

## Features

| ID | Feature | Status | Spec |
|---|---|---|---|
| 001 | {inferred feature name} | implemented | — |

## Status Values

- `planned` — not yet started
- `in-progress` — spec written, implementation underway
- `implemented` — decision record complete
- `deprecated` — removed from product

## Revision History

| Date | Change |
|---|---|
| {date} | Initial roadmap inferred by audit skill |
```

---

## Completion Criteria

- [ ] Discovery pass complete before any writing began
- [ ] Verification dialogue ran (or `--quick` was explicitly invoked)
- [ ] Reflect-back was presented and the human confirmed, corrected, or accepted items as uncertain
- [ ] Items confirmed by the human are no longer marked uncertain in the docs
- [ ] Items still uncertain after dialogue are flagged `[INFERRED: uncertain — please verify]`
- [ ] All three files exist in `docs/specs/`
- [ ] All required sections populated or explicitly marked `[INFERRED: uncertain]`
- [ ] Status set to `inferred` in all three files
- [ ] `inferred-from` field lists the key files that drove each doc
- [ ] Audit Notes section in `OVERVIEW.md` captures gaps and uncertainties

---

## Next Steps

After audit:

1. Human reviews all three docs, corrects `[INFERRED: uncertain]` fields
2. Set status to `approved` when confident in accuracy
3. Decide whether gap findings warrant bug fixes or new feature specs
4. For new features, create `docs/specs/{NNN}-{feature-name}/spec.md`
5. For bug fixes, use the `ss-fix` skill
