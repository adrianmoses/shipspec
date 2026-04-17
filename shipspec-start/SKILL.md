# Skill: shispec-start

Scaffold the full spec suite for a new project. Run this once at the start of a project before any feature work begins. Output is the three repo-level docs that all subsequent skills depend on.

---

## When to Use

- A new project or repository is being started from scratch
- No `docs/specs/` directory exists yet
- You have a product idea, brief, or description to work from

Do not use this skill on existing projects. Use the `audit` skill instead.

---

## Inputs

Gather the following before proceeding. If any are missing, ask before generating.

| Input | Required | Description |
|---|---|---|
| Product description | Yes | What the product does and who it is for |
| Tech stack | Yes | Languages, frameworks, infrastructure |
| Testing approach | Yes | Unit, integration, e2e — tools and conventions |
| Initial feature list | No | Known features for the roadmap. Can be rough. |
| Non-goals | No | Explicit things this product will not do |

---

## Output

Three files created in `docs/specs/`:

```
docs/specs/
  OVERVIEW.md
  ARCHITECTURE.md
  ROADMAP.md
```

---

## Steps

### 1. Create `docs/specs/OVERVIEW.md`

Use the template below. All required sections must be populated. Optional sections may be omitted with a one-line note.

```markdown
# Overview

<!-- status: draft | approved -->
| Field | Value |
|---|---|
| status | draft |
| created | {date} |

## Product Summary <!-- required -->

{One paragraph. What this product does and the problem it solves.}

## Target Consumer <!-- required -->

{Who uses this. Be specific. If the consumer is another system or agent, name it.}

## Job To Be Done <!-- required -->

{What the consumer is hiring this product to do. One or two sentences.}

## Non-Goals <!-- required -->

{What this product explicitly does not do. Bullet list.}

## Tech Stack <!-- required -->

{Languages, frameworks, key libraries, infrastructure. Bullet list.}

## Testing Suite <!-- required -->

{Testing approach, tools, and conventions. Bullet list. This section is load-bearing —
test evidence in decision records references this.}

## Open Questions <!-- optional -->

{Unresolved decisions that affect scope or architecture.}
```

---

### 2. Create `docs/specs/ARCHITECTURE.md`

```markdown
# Architecture

<!-- status: draft | approved -->
| Field | Value |
|---|---|
| status | draft |
| created | {date} |

## System Overview <!-- required -->

{High-level description of the system. How the major components relate.}

## Component Map <!-- required -->

{List or diagram of major components and their responsibilities.}

## Data Flow <!-- required -->

{How data moves through the system. Key inputs, transformations, outputs.}

## External Dependencies <!-- required -->

{Third-party services, APIs, or systems this product depends on.}

## Key Constraints <!-- required -->

{Technical constraints that shape design decisions. Performance, scale, compliance, etc.}

## Open Decisions <!-- optional -->

{Architecture decisions not yet resolved. Each should reference a feature spec or ADR
when resolved.}
```

---

### 3. Create `docs/specs/ROADMAP.md`

```markdown
# Roadmap

<!-- status: draft | approved -->
| Field | Value |
|---|---|
| status | draft |
| created | {date} |

## Features

| ID | Feature | Status | Spec |
|---|---|---|---|
| 001 | {feature name} | planned | — |

## Status Values

- `planned` — not yet started
- `in-progress` — spec written, implementation underway
- `implemented` — decision record complete
- `deprecated` — removed from product

## Revision History

| Date | Change |
|---|---|
| {date} | Initial roadmap created |
```

---

## Completion Criteria

- [ ] All three files exist in `docs/specs/`
- [ ] All required sections populated in each file
- [ ] Status set to `draft` in all three
- [ ] Roadmap includes at least one feature row if an initial feature list was provided

---

## Next Steps

After initialization:

1. Review all three docs and set status to `approved` when ready
2. For each roadmap feature, create `docs/specs/{NNN}-{feature-name}/spec.md`
3. Use the `implement` skill to execute against each spec
