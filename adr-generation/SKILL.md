---
name: adr-generation
description: >
  Draft an Architecture Decision Record (ADR) entry during AI-assisted development.
  Trigger this skill after a spec has been accepted and a plan has been approved —
  before implementation is complete. Activate when you see: a spec handoff summary
  marked "Spec accepted ✓", an approved implementation plan, or phrases like "let's
  document this decision", "update DECISIONS.md", "write the ADR", or "capture this".
  Also trigger proactively at the transition point between planning and implementation
  — if a plan has just been approved and no ADR has been drafted, suggest it before
  any code is written. Do not wait to be asked. The ADR should be drafted while
  decisions are fresh, not reconstructed after the fact.
---

# ADR Generation

Drafts an Architecture Decision Record from the accepted spec and approved plan.
The agent drafts; the developer authors. Deliberate blanks are left for things only
the developer can fill in — tradeoffs accepted, alternatives genuinely considered,
anything that changed from the original spec. The developer edits and commits the
ADR alongside the implementation.

## Core behavior

1. Collect inputs: the spec handoff summary and the approved implementation plan.
   If either is missing, ask for it before drafting.
2. Draft the ADR using the template below, populated from what is known.
3. Leave explicit `[YOUR INPUT NEEDED]` markers for fields the developer must fill
   in. Do not invent alternatives, tradeoffs, or consequences — these must come
   from the developer.
4. Present the draft and ask the developer to review and complete the marked fields.
5. Once the developer has filled in the blanks, produce the final ADR formatted for
   appending to `DECISIONS.md`.
6. Remind the developer to commit `DECISIONS.md` alongside the implementation.

**The agent drafts. The developer authors. Never invent decisions.**

---

## Inputs

### Required
- **Spec handoff summary** — the "Spec accepted ✓" block produced by the
  spec-enforcement skill, or equivalent spec content
- **Approved implementation plan** — the numbered plan the developer signed off on
  before implementation began

### Optional but valuable
- Any decisions made during the planning review (things that changed from the
  original spec)
- Any open questions that were resolved during planning

---

## ADR template

```markdown
# ADR-[NNN]: [title — what was decided, not what was built]

**Date:** [YYYY-MM-DD]
**Status:** Accepted
**Author:** [YOUR INPUT NEEDED — your name or handle]

---

## Context

<!-- What situation made this decision necessary? Populated from the spec objective.
     Should read as: "We needed to decide X because Y." -->
[Drafted from spec objective — review and edit for accuracy]

## Decision

<!-- What was decided. One clear statement. Populated from the spec interface and
     the approved plan. -->
[Drafted from spec and plan — review and edit for precision]

## What this does not do

<!-- Explicit scope boundary. Populated from the spec out-of-scope list.
     This section prevents future scope creep by making exclusions a first-class
     part of the decision. -->
[Drafted from spec out-of-scope — review and add anything missing]

## Alternatives considered

<!-- [YOUR INPUT NEEDED]
     What else was on the table before this approach was chosen?
     Even if the decision felt obvious, name the alternatives — including "don't
     build this" and "use an existing solution." Future readers need to understand
     why this path was taken, not just what it is.

     Format:
     - **[Alternative]:** [why it was ruled out]
-->
[YOUR INPUT NEEDED]

## Tradeoffs accepted

<!-- [YOUR INPUT NEEDED]
     What does this decision make harder, slower, or more constrained?
     Every architectural decision has costs. Name them honestly.
     These are the things that will matter when this decision is revisited.

     Format:
     - [Tradeoff]: [why it was accepted]
-->
[YOUR INPUT NEEDED]

## Implementation notes

<!-- Non-obvious choices made during implementation that future engineers need
     to know. Populated from the approved plan and any decisions made during
     the planning review. -->
[Drafted from approved plan — review and add anything that changed during implementation]

## Consequences

<!-- [YOUR INPUT NEEDED — partially]
     What becomes easier because of this decision?
     What becomes harder?
     What decisions does this constrain in the future?

     Format:
     - **Easier:** [list]
     - **Harder:** [list]
     - **Constrains:** [list]
-->
**Easier:** [Drafted from spec objective — review and extend]
**Harder:** [YOUR INPUT NEEDED]
**Constrains:** [YOUR INPUT NEEDED]

## Open questions at time of decision

<!-- Any questions that were unresolved when this decision was made.
     Populated from the spec open questions list. If all were resolved,
     state that explicitly. -->
[Drafted from spec open questions — update to reflect what was resolved vs. deferred]

---

*Related: [link to relevant code, PR, or other ADR if applicable]*
```

---

## Drafting rules

When populating the template from the spec and plan:

**Draft from spec:**
- Context → from the spec objective
- Decision → from the spec interface definition + plan summary
- What this does not do → from the spec out-of-scope list
- Open questions → from the spec open questions list

**Draft from plan:**
- Implementation notes → from the numbered plan steps, highlighting non-obvious choices
- Consequences (Easier) → inferred from the spec objective and plan

**Always leave blank (never invent):**
- Alternatives considered — only the developer knows what was genuinely on the table
- Tradeoffs accepted — only the developer can speak to what costs were knowingly accepted
- Consequences (Harder, Constrains) — requires developer judgment about system impact
- Author field — always `[YOUR INPUT NEEDED]`

**Flag changes from spec:**
If the approved plan deviates from the original spec in any way, call this out
explicitly in the draft:

```
⚠️  Note: The approved plan differs from the spec in the following ways:
- [spec said X, plan does Y — confirm this should be reflected in the ADR]
```

These deviations are often the most important things to capture in the ADR.

---

## Validation before finalizing

Before producing the final ADR, verify:

- [ ] No `[YOUR INPUT NEEDED]` fields remain empty
- [ ] Alternatives considered contains at least two real alternatives (including
      "don't build this" if relevant)
- [ ] Tradeoffs accepted is honest — not a list of non-costs
- [ ] The decision statement is precise enough that a new engineer could understand
      what was chosen without reading the code
- [ ] What this does not do is specific (not "doesn't handle all edge cases")
- [ ] Any spec deviations are reflected in the ADR, not just the code
- [ ] Open questions notes which were resolved and which remain deferred

If any fields are still marked `[YOUR INPUT NEEDED]` after developer review, ask
again rather than proceeding with gaps. An incomplete ADR is worse than no ADR —
it creates false confidence that the decision was documented.

---

## Final output format

Once the developer has completed all fields, produce the final ADR in this format
for appending to `DECISIONS.md`:

```markdown
---

[completed ADR content]

---
```

Then produce this commit reminder:

```
ADR drafted. Before moving to the next unit of work:

- [ ] Edit any remaining fields that need refinement
- [ ] Append to DECISIONS.md
- [ ] Commit DECISIONS.md in the same PR/commit as the implementation

The ADR is part of the implementation, not an afterthought.
```

---

## DECISIONS.md structure

If `DECISIONS.md` does not exist in the project, suggest creating it with this header:

```markdown
# Architecture decisions

A record of significant decisions made during development. Each entry captures
the context, what was decided, what was ruled out, and what tradeoffs were
knowingly accepted.

Entries are numbered sequentially. Status is one of:
- **Accepted** — active decision
- **Superseded by ADR-NNN** — replaced by a later decision
- **Deprecated** — no longer relevant

---
```

ADR numbers increment from the last entry. If no entries exist, start at ADR-001.
