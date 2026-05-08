# Skill: ss-initialize

Scaffold the full spec suite for a new project. Run this once at the start of a project before any feature work begins. Output is the three repo-level docs that all subsequent skills depend on.

---

## When to Use

- A new project or repository is being started from scratch
- No `docs/specs/` directory exists yet
- You have a product idea, brief, or description to work from

Do not use this skill on existing projects. Use the `ss-audit` skill instead.

---

## Inputs

The discovery dialogue in Step 2 below collects these. They are listed here so the human knows what the conversation will cover.

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

The repo-level docs are the foundation every other shipspec skill builds on. They are co-developed with the human, not agent-drafted-then-reviewed. Run discovery before drafting so the three files reflect shared intent.

### 1. Read provided context

If the human supplied a brief, README, design note, or any document describing the product, read it in full before opening dialogue. If the project directory already contains a `README.md`, an architecture sketch, or notes, read those too. If there is nothing to read, proceed straight to discovery — that is the common case for greenfield projects.

### 2. Run the discovery dialogue

**Frame.** State in one line what is about to happen: *"I'll ask up to a few questions to ground the three docs, then propose a draft for you to react to before I write the files."*

**Probe.** Ask the questions below, in order, with a hard cap of 5 total. Skip any whose answer is already in the human's brief or earlier conversation context — surface the inferred answer in the reflect-back instead of asking. Aim for the smallest set of questions that resolves real ambiguity, not a checklist.

1. **Consumer and job-to-be-done.** Describe the consumer and what they're hiring this product to do. Be specific — if the consumer is another system or agent, name it. What problem does it solve for them?
2. **Non-goals.** What would make a user *stop* using this, or what jobs are you explicitly *not* doing? Naming what's out is often more clarifying than what's in.
3. **Tech stack and constraints.** Languages, frameworks, infrastructure. Anything load-bearing or non-negotiable — compliance, latency, scale, deployment, license?
4. **Testing posture.** What level of testing rigor is right for this product, and what tools fit? Decision records reference the testing suite as evidence — set the bar honestly.
5. **Roadmap seed.** What features make up the first 3–6 months? Rough is fine; order matters more than completeness. An architecture sketch will be proposed in the reflect-back based on what's been said.

If a question's answer is fully determined by context (≈80%+ confidence), do not ask it — note in the reflect-back that it was inferred, and from where.

**Reflect.** When probing is done, present a single batched summary shaped like the three documents. The architecture section is mostly agent-proposed — the human's job here is to react, not to spec it from scratch:

```
Here's what I heard (✓ = your answer, • = inferred from {source}):

OVERVIEW
- Product summary:  ✓ {…}
- Consumer:         ✓ {…}
- Job to be done:   ✓ {…}
- Non-goals:        ✓ {…}
- Tech stack:       ✓ {…}
- Testing suite:    ✓ {…}

ARCHITECTURE (sketch — react to it)
- System overview:  • {…}
- Component map:    • {…}
- Data flow:        • {…}
- External deps:    • {…}
- Key constraints:  ✓ {…}

ROADMAP
- Features (ordered): ✓ {…}

Anything to correct before I draft the three files?
```

Wait for explicit approval or correction before proceeding. If the human substantially redirects on architecture, that is expected — it is the section they had least context to react to during probing, and the sketch's job is to surface the disagreement.

### 3. Draft the three docs

Render the templates below in order: `OVERVIEW.md`, `ARCHITECTURE.md`, then `ROADMAP.md`. Every section must trace back to either a dialogue answer or an inference stated in the reflect-back. Do not introduce new claims at draft time that were not surfaced during dialogue.

### 4. Hand off for review

Present the three drafted files for the human to review and set status `draft` → `approved`. If they redirect substantially after seeing the drafts, return to step 2 — do not patch the files in place from a different mental model than the dialogue produced.

### Opt-out: quick mode

If the human invokes the skill with `--quick`, or supplies a complete brief that already answers all five probe questions, skip step 2's dialogue entirely. Draft directly from context, and surface every ambiguity as either an `Open Questions` entry (OVERVIEW) or an `Open Decisions` entry (ARCHITECTURE) — naming what was assumed and what would resolve it. This preserves the one-shot path for humans who already have the project shape in their head.

---

## Templates

### OVERVIEW.md

All required sections must be populated. Optional sections may be omitted with a one-line note.

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

### ARCHITECTURE.md

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

### ROADMAP.md

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

- [ ] Discovery dialogue ran (or `--quick` was explicitly invoked)
- [ ] Reflect-back was presented and the human approved or corrected before drafting
- [ ] Architecture sketch was confirmed (since it is mostly inferred from tech stack and roadmap)
- [ ] All three files exist in `docs/specs/`
- [ ] All required sections populated in each file
- [ ] Every section traces back to a dialogue answer or a stated inference — no new claims introduced at draft time
- [ ] Status set to `draft` in all three
- [ ] Roadmap includes at least one feature row if a feature list was discussed during dialogue

---

## Next Steps

After initialization:

1. Review all three docs and set status to `approved` when ready
2. For each roadmap feature, use the `ss-spec` skill to create `docs/specs/{NNN}-{feature-name}/spec.md`
3. Use the `ss-plan` skill to plan implementation against each approved spec
4. After implementation, use the `ss-decision` skill to record what was built and any spec divergence
