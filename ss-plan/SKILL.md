# Skill: ss-plan

Produce an implementation plan against an approved feature spec. The plan is the bridge between `spec.md` (the contract) and `decision.md` (the record). It is written before any code is changed and lives in the agent's working context, not on disk.

This skill exists so that the spec is read carefully, the approach is reasoned about explicitly, and the human has a chance to redirect before implementation begins.

---

## When to Use

- A `spec.md` exists with status `approved`
- You are about to begin implementation against that spec
- Significant scope or approach change requires re-planning mid-implementation

Do not use this skill for bug fixes — `ss-fix` covers investigation and scoping for those. Do not use this skill before a spec exists — invoke `ss-spec` first.

---

## Inputs

| Input | Required | Description |
|---|---|---|
| Feature spec | Yes | `docs/specs/{NNN}-{feature-name}/spec.md` for the feature being implemented |
| Additional guidance | No | Any human direction beyond what the spec captures |

### Locating the spec

Before producing a plan, confirm which spec is being implemented:

1. If a `spec.md` is already in the conversation context (read earlier this session, referenced by the user, or open in the editor), use that as the input.
2. If no spec is in context, **stop and ask the user**:
   - Which spec should be planned against? (e.g. `docs/specs/003-feature-name/spec.md`)
   - Or, if no spec exists yet, invoke the `ss-spec` skill first to create one.

   Do not guess the spec or scan the repo for the most recent one — the wrong spec produces the wrong plan.

3. Read the full spec before planning. The plan must cite acceptance criteria, non-goals, and the approach section verbatim where relevant.

---

## Steps

### 1. Switch to plan mode

If the harness exposes a plan mode (e.g. Claude Code's `ExitPlanMode` flow), enter it before producing the plan. Plan mode prevents accidental edits while the approach is being reasoned about and signals to the human that no code is being changed yet.

If plan mode is not available, proceed by producing the plan as text and explicitly stating that no edits will be made until the human approves.

### 2. Read the spec end-to-end

Do not summarize from memory. Re-read:

- The `Why` section — so the plan keeps the consumer in view
- `Acceptance Criteria` — every criterion must be addressed by the plan
- `Non-Goals` — the plan must not expand into these
- `Approach` and `Key Decisions` — the plan refines these, it does not replace them
- `Confidence` — if Medium or Low, the plan must include the validation steps

### 3. Produce the plan

Use the template below. Keep it tight — this is a working document, not a deliverable. The goal is to make the implementation order explicit and let the human catch problems before code is written.

### 4. Hand off for approval

Present the plan to the user. Do not begin implementation until the human approves the plan or redirects. If plan mode is active, exit it only after approval.

---

## Template

```markdown
# Plan: {Feature Name}

| Field | Value |
|---|---|
| spec | [spec.md](./docs/specs/{NNN}-{feature-name}/spec.md) |
| created | {date} |

---

## Spec Summary

{Two or three sentences restating what is being built and for whom. Confirms
the spec was read; gives the human a chance to correct misunderstanding before
work begins.}

---

## Implementation Steps

{Ordered list of concrete steps. Each step names the files to be touched and
the change being made. Steps should be small enough to verify individually.}

1. {step} — {files involved}
2. {step} — {files involved}

---

## Acceptance Criteria Coverage

{Map each acceptance criterion from the spec to the step(s) that satisfy it.
Surfaces uncovered criteria before implementation begins.}

| Criterion | Covered By |
|---|---|
| {criterion from spec} | {step number(s)} |

---

## Risks and Open Questions

{Anything that could derail the plan: unknowns, dependencies on other work,
ambiguities in the spec that surfaced while planning. If the spec's confidence
was Medium or Low, list the validation steps here.}

---

## Out of Scope

{Anything the human or agent might expect to be in this plan but is not —
typically because it falls under the spec's Non-Goals or belongs to a later
roadmap item.}
```

---

## Completion Criteria

- [ ] Spec was read in full before the plan was produced
- [ ] Every acceptance criterion is mapped to at least one step
- [ ] No step expands into a Non-Goal from the spec
- [ ] Risks and open questions are surfaced explicitly
- [ ] Human has approved the plan before implementation begins

---

## Next Steps

1. Human reviews plan and approves or redirects
2. Implement the feature against the approved plan
3. After implementation, use the `ss-decision` skill to produce the decision record
