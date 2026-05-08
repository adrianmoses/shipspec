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

The repo-level docs (`OVERVIEW.md`, `ARCHITECTURE.md`, `ROADMAP.md`) are read as part of Step 1 below.

---

## Output

```
docs/specs/{NNN}-{feature-name}/
  spec.md
```

Update `ROADMAP.md` feature status from `planned` to `in-progress`.

---

## Steps

The spec is a thinking doc, and the thinking happens *with* the human, not in the agent's head alone. Run discovery before drafting so the spec reflects shared intent, not the agent's best guess.

### 1. Read the repo-level docs

Before any dialogue, read in full:

- `docs/specs/OVERVIEW.md` — consumer and product context
- `docs/specs/ARCHITECTURE.md` — technical constraints
- `docs/specs/ROADMAP.md` — the feature's place in sequence and any neighbors that depend on it or block it

The discovery dialogue is grounded in these docs. Any question whose answer is already there should not be asked.

### 2. Run the discovery dialogue

**Frame.** State in one line what is about to happen: *"I'll ask up to a few questions to ground the spec, then propose a draft for you to react to before I write the file."*

**Probe.** Ask the questions below, in order, with a hard cap of 5 total. Skip any whose answer is already in OVERVIEW / ARCHITECTURE / ROADMAP or earlier conversation context — surface the inferred answer in the reflect-back instead of asking. Aim for the smallest set of questions that resolves real ambiguity, not a checklist.

1. **Consumer alignment.** OVERVIEW names consumer `{X}`. Does this feature serve them, or a different / narrower consumer? If different, who?
2. **Why, in one sentence.** Propose a draft Why: *"This feature exists because {…}."* Confirm or correct.
3. **Approach options.** Sketch the two most plausible approaches: A `{one-line sketch}` vs B `{one-line sketch}`. Name the central tradeoff between them. Ask which fits, or whether a third option is on the table.
4. **Confidence and falsification.** State current confidence (`High | Medium | Low`) and *why*. If not High, ask what would falsify the approach — the validation step that should run before full implementation.
5. **Non-goals worth naming.** Ask which adjacent capabilities the human explicitly does *not* want this feature to grow into. Surface any obvious-but-implicit ones for confirmation.

If a question's answer is fully determined by context (≈80%+ confidence), do not ask it — note in the reflect-back that you inferred it and from where.

**Reflect.** When probing is done, present a single batched summary in the shape of the spec's required sections:

```
Here's what I heard (✓ = your answer, • = inferred from {source}):

- Consumer:    ✓ {…}
- Why:         ✓ {…}
- Approach:    ✓ {…}
- Confidence:  ✓ {High | Medium | Low} — validate by {…}
- Non-goals:   • {…}  (inferred from ROADMAP item 004)

Anything to correct before I draft?
```

Wait for explicit approval or correction before proceeding. If the human redirects substantially, run another short pass — do not patch the reflect-back silently.

### 3. Draft the spec

Render the template (below) using the dialogue's outputs. Every required section must trace back to either an answer the human gave or an inference stated in the reflect-back. Do not introduce new claims at draft time that were not surfaced during dialogue.

### 4. Hand off for review

Present the drafted spec for the human to set status `draft` → `approved`. If they redirect substantially after seeing the draft, return to step 2 — do not patch the spec in place from a different mental model than the dialogue produced.

### Opt-out: quick mode

If the human invokes the skill with `--quick`, or explicitly asks to "just draft it," skip step 2's dialogue entirely. Read the repo-level docs, draft directly from context, and set `Confidence: Low` on any section where dialogue would have helped — with rationale naming what was assumed. This preserves the one-shot path for cases where the human already has the spec in their head.

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

- [ ] Repo-level docs were read in full before discovery began
- [ ] Discovery dialogue ran (or `--quick` was explicitly invoked)
- [ ] Reflect-back was presented and the human approved or corrected before drafting
- [ ] All required sections populated
- [ ] Every section traces back to a dialogue answer or a stated inference — no new claims introduced at draft time
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
