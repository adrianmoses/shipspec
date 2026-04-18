# Skill: ss-decision

Generate a decision record for a completed feature. This is a record doc written after implementation. It captures the context that drove the work, alternatives that were considered, tradeoffs that were made, and the decisions that were reached. It is honest about where the implementation diverged from the spec and why.

---

## When to Use

- A feature implementation is complete
- All acceptance criteria in `spec.md` have been addressed
- Tests are passing

Do not use this skill mid-implementation. The decision record reflects what was actually built, not what is planned.

---

## Inputs

| Input | Required | Description |
|---|---|---|
| Feature spec | Yes | `docs/specs/{NNN}-{feature-name}/spec.md` |
| Implementation | Yes | The code that was written |
| Test output | Yes | Actual test results to include as evidence |

Before writing, read:
1. `spec.md` for this feature — the baseline all decisions are measured against
2. The implementation — what was actually built
3. Test output — evidence of correctness

---

## Output

```
docs/specs/{NNN}-{feature-name}/
  spec.md       ← already exists
  decision.md   ← created by this skill
```

Update `ROADMAP.md` feature status from `in-progress` to `implemented`.

---

## Template

```markdown
# Decision Record: {Feature Name}

| Field | Value |
|---|---|
| id | {NNN} |
| status | implemented |
| created | {date} |
| spec | [spec.md](./spec.md) |

---

## Context <!-- required -->

{What drove this feature at the time of implementation. Include any factors that
shaped the work beyond what the spec captured — time constraints, discoveries
made during implementation, upstream changes, feedback received. This is the
"what was actually going on" section.}


## Decision <!-- required -->

{A clear, direct statement of what was decided and why. This should be
readable in isolation — someone who has not read the rest of this document
should understand what was built and the core rationale.}

---

## Alternatives Considered <!-- required -->

{For each meaningful decision made during implementation, list the alternatives
that were considered. If only one approach was ever on the table, say so and
explain why.}

### {Decision Point}

**Option A:** {description}
- Pros: {tradeoffs}
- Cons: {tradeoffs}

**Option B:** {description}
- Pros: {tradeoffs}
- Cons: {tradeoffs}

**Chosen:** {which option and why}

---

## Tradeoffs <!-- required -->

{What did the chosen approach give up? What does it optimise for? This section
makes the cost of the decision explicit so future agents and humans can
understand the constraints that were accepted.}

---

### Spec Divergence <!-- optional -->

{Did the implementation match the spec? If yes, state that clearly. If not,
list every divergence and the reason for it. A divergence is not a failure — it
is information. Unexplained divergence is a problem.}

| Spec Said | What Was Built | Reason |
|---|---|---|
| {spec intent} | {implementation reality} | {why} |

---


## Spec Gaps Exposed <!-- optional -->

{Did this implementation reveal gaps, ambiguities, or errors in the spec, the
overview, or the architecture doc? List them here. Each gap is a candidate for
a follow-up spec revision or a new roadmap item.}

---

## Test Evidence <!-- required -->

{Actual test output demonstrating the feature works as specified. Do not
summarise — include the output or reference the CI run. A checkbox is not
evidence.}

\`\`\`
{test output}
\`\`\`
```

---

## Completion Criteria

- [ ] All required sections populated
- [ ] Spec divergence table completed — even if empty (state that explicitly)
- [ ] At least one alternatives section for each meaningful decision
- [ ] Test evidence is actual output, not a summary
- [ ] Spec gaps noted if any were discovered
- [ ] Status set to `implemented`
- [ ] `ROADMAP.md` updated to `implemented`

---

## Next Steps

1. Human reviews decision record
2. If spec gaps were noted, assess whether they warrant a spec revision or new roadmap item
3. Feature is complete — move to next roadmap item
