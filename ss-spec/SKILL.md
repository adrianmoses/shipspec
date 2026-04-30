# Skill: spec

Generate a feature spec for a planned roadmap item. This is a thinking doc written before implementation begins. It captures why the feature exists, what it does, and how it will be built. The agent uses this as its primary input during implementation.

---

## When to Use

- A feature exists in `ROADMAP.md` with status `planned`
- You are about to begin implementation of a new feature
- A feature needs to be re-specced due to significant scope change

Do not use this skill for bug fixes. Use the `fix` skill instead.

---

## Inputs

| Input | Required | Description |
|---|---|---|
| Feature name / roadmap ID | Yes | The feature being specced |
| Consumer context | No | Who uses this and what they need — pulled from `OVERVIEW.md` if not provided |
| Technical context | No | Relevant architecture constraints — pulled from `ARCHITECTURE.md` if not provided |
| Additional guidance | No | Any human direction on approach, constraints, or priorities |

Before writing, read:
1. `docs/specs/OVERVIEW.md` — for consumer and product context
2. `docs/specs/ARCHITECTURE.md` — for technical constraints
3. `docs/specs/ROADMAP.md` — for sequencing and dependencies

---

## Output

```
docs/specs/{NNN}-{feature-name}/
  spec.md
```

Update `ROADMAP.md` feature status from `planned` to `in-progress`.

---

## Template

```markdown
# Spec: {Feature Name}

| Field | Value |
|---|---|
| id | {NNN} |
| status | draft |
| created | {date} |

---

## Why <!-- required -->

{Why does this feature exist? What consumer need does it serve? How does it
advance the product? This should be answerable without referencing the
implementation — it is the justification that survives any technical change.}

### Consumer Impact <!-- required -->

{Who benefits from this feature and how. Be specific. If the consumer is
another system or agent, name it and describe the integration point.}

### Roadmap Fit <!-- required -->

{Why this feature at this point in the roadmap. Dependencies on prior features,
or features that depend on this one.}

---

## What <!-- required -->

### Acceptance Criteria <!-- required -->

{Ordered list of conditions that must be true for this feature to be considered
complete. Written from the consumer's perspective where possible.}

- [ ] {criterion}

### Non-Goals <!-- required -->

{What this feature explicitly does not do. Prevents scope creep during
implementation.}

### Open Questions <!-- optional -->

{Unresolved questions that could affect scope or approach. Each should be
resolved before status is set to approved, or explicitly deferred with a reason.}

---

## How <!-- required -->

### Approach <!-- required -->

{Description of the implementation plan. Key components, data flow, integration
points. Enough detail that an agent can begin without ambiguity.}

### Confidence <!-- required -->

{Rate the confidence in this approach: High / Medium / Low}

**Level:** {High | Medium | Low}

**Rationale:** {Why this confidence level. What is well-understood, what is
uncertain, and what should be validated before committing to the approach.}

**Validate before proceeding:** {List any spikes, proofs of concept, or
clarifying questions that should be resolved before full implementation if
confidence is Medium or Low. Omit if High.}

### Key Decisions <!-- optional -->

{Technical decisions with meaningful tradeoffs that are being made in this spec.
Decisions made during implementation belong in the decision record.}

### Testing Approach <!-- required -->

{How this feature will be tested. Reference the testing suite defined in
OVERVIEW.md. List specific test cases or scenarios required to satisfy
acceptance criteria.}
```

---

## Completion Criteria

- [ ] All required sections populated
- [ ] Acceptance criteria written from consumer perspective
- [ ] Confidence level set with rationale
- [ ] If confidence is Medium or Low, validation steps are listed
- [ ] Open questions are resolved or explicitly deferred
- [ ] Status set to `draft`
- [ ] `ROADMAP.md` updated to `in-progress`

---

## Next Steps

1. Human reviews spec and sets status to `approved`
2. Implement the feature against the spec
3. After implementation, use the `decision` skill to produce the decision record
