# Skill: shipspec-audit

Reverse-engineer the spec suite for an existing project by reading the codebase. Output is the same three repo-level docs that `initialize` produces, but with status `inferred`. Once complete, the project is on the canonical shipspec path.

---

## When to Use

- An existing project has no `docs/specs/` directory
- A project was started without shipspec and needs to be brought onto the workflow
- The codebase is not well understood and needs to be documented before a bug fix or new feature

Do not use this skill on new projects. Use the `initialize` skill instead.

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

Record findings in a `## Audit Notes` section appended to `00-overview.md`. These are not part of the canonical spec — they are inputs for the human to review.

---

### 3. Create `docs/specs/OVERVIEW.md`

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

### 4. Create `docs/specs/ARCHITECTURE.md`

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

### 5. Create `docs/specs/ROADMAP.md`

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
- [ ] All three files exist in `docs/specs/`
- [ ] All required sections populated or explicitly marked `[INFERRED: uncertain]`
- [ ] Status set to `inferred` in all three files
- [ ] `inferred-from` field lists the key files that drove each doc
- [ ] Audit Notes section in `00-overview.md` captures gaps and uncertainties

---

## Next Steps

After audit:

1. Human reviews all three docs, corrects `[INFERRED: uncertain]` fields
2. Set status to `approved` when confident in accuracy
3. Decide whether gap findings warrant bug fixes or new feature specs
4. For new features, create `docs/specs/{NNN}-{feature-name}/spec.md`
5. For bug fixes, use the `fix` skill
