---
name: comprehension-check
description: >
  Run a Socratic comprehension check at the end of an AI-assisted development session
  to ensure the developer genuinely understands what was built before moving on.
  Trigger this skill after implementation is complete and the ADR has been drafted —
  at the natural "wrap up" point of a unit of work. Activate when you see: a completed
  ADR, phrases like "that's done", "let's move on", "what's next", "ship it", or
  "looks good to me". Also trigger proactively if implementation has been running for
  several turns without a pause for reflection. Do not let the developer move on to
  the next unit of work until the check is complete. The goal is consolidation of
  understanding, not a gotcha — frame it that way.
---

# Comprehension Check

A Socratic check at the end of each unit of work. Probes whether the developer
genuinely understands what was built — not whether they can recite it. Shallow
answers get a follow-up. The check targets the non-obvious decisions from the ADR,
not the surface behavior anyone could infer from the code.

This is not a quiz. There are no right or wrong answers. The goal is to surface
gaps in understanding before they become debugging sessions or architectural
mistakes in the next unit of work.

## Core behavior

1. Collect inputs: the completed ADR and a summary of what was implemented.
   If the ADR is missing, note it and work from the spec and implementation instead.
2. Identify the 2–3 most non-obvious aspects of what was built (see targeting rules).
3. Ask one question at a time. Do not front-load all questions.
4. Evaluate the response for depth, not correctness (see evaluation rubric).
5. If the response is shallow, ask one follow-up. Do not drill more than one level.
6. After 2–3 questions, produce the session summary and clear the developer to
   move on.

**One question at a time. Socratic, not interrogative. Always frame as consolidation.**

---

## Opening framing

Always open the check with a framing statement before the first question. Tone
matters — this should feel like a colleague asking "walk me through it" not an
examiner testing recall.

Use one of these openings, adapted to context:

> "Before we move on — let's make sure this is solid in your head, not just in
> the code. Walk me through [targeted aspect]."

> "Quick consolidation before the next task. [Question]"

> "This had some non-obvious parts. [Question] — just want to make sure that's
> clear before it becomes someone else's debugging problem."

Never open with "I'm going to test you on" or "Let's see if you understood" —
these frames create defensiveness rather than reflection.

---

## Question targeting rules

Questions should target the aspects most likely to cause problems later if
misunderstood. Pull from the ADR in this priority order:

**Priority 1 — Tradeoffs accepted**
These are the decisions that will bite hardest if forgotten. A developer who
can't articulate a tradeoff they accepted will almost certainly violate it in
a future unit of work.

Example question forms:
- "You accepted [tradeoff] here. When would that become a problem in practice?"
- "What's the scenario where the decision to [X] starts to hurt?"
- "If [assumption] turns out to be wrong, what breaks first?"

**Priority 2 — What this does not do**
Scope boundaries are the most common source of future scope creep and
misuse. A developer who can't articulate what was explicitly excluded will
let it creep back in.

Example question forms:
- "What's the closest thing to [excluded feature] that this deliberately
  doesn't handle?"
- "If a future engineer wanted to add [out-of-scope thing], where would
  they need to change this?"
- "What assumption would have to be true for [out-of-scope thing] to be
  safe to add later?"

**Priority 3 — Non-obvious implementation choices**
From the implementation notes in the ADR. These are the choices that look
arbitrary in the code but have a reason behind them.

Example question forms:
- "Why [specific implementation choice] rather than the more obvious
  [alternative]?"
- "What would break if someone changed [non-obvious detail] without
  understanding why it's there?"
- "The [specific pattern] here is not the most obvious approach. What
  does it buy us?"

**Priority 4 — Error handling and edge cases**
From the spec error cases and test criteria. These tend to be the first
things forgotten after implementation.

Example question forms:
- "Walk me through what happens when [error condition] occurs."
- "What's the difference between [error case A] and [error case B] from
  the caller's perspective?"
- "If [edge case] hit production today, what would the caller see?"

---

## Evaluation rubric

Evaluate responses on depth, not correctness. The goal is to distinguish
genuine understanding from surface recall.

**Deep response — clear to proceed:**
- Connects the implementation detail to a consequence or scenario
- Mentions a constraint, limitation, or failure mode unprompted
- Uses concrete examples rather than abstract descriptions
- Acknowledges uncertainty honestly ("I'm not sure what happens if X")

**Shallow response — ask one follow-up:**
- Restates what the code does without explaining why
- Uses the same words as the question without adding meaning
- Describes the happy path only, ignoring error cases or tradeoffs
- Confident but vague ("it handles that correctly")

**Stuck response — offer a hint, then move on:**
- Developer genuinely doesn't know ("I'm not sure")
- Developer is going in circles
- In this case: provide the explanation, note it as a gap in the session
  summary, and move on. The goal is learning, not blocking.

---

## Follow-up question forms

Use these when a response is shallow. Ask only one follow-up per question —
don't drill.

- "What would that look like in practice — can you give a concrete example?"
- "What's the scenario where that becomes a problem?"
- "You said [their answer] — what does that mean for [downstream caller /
  future engineer / error condition]?"
- "What would have to change if [assumption underlying their answer]
  turned out to be false?"

---

## SongDNA-specific probes

For work in the SongDNA context, these aspects are consistently non-obvious
and high-value to probe:

**Entity resolution:**
- How does this behave when confidence is below the resolution threshold?
- What happens to tracks that match multiple entities?
- Is the behavior deterministic across re-runs, or does it depend on
  dataset state?

**Scale and performance:**
- At 300M+ tracks, what's the failure mode if [assumption] doesn't hold?
- How does this behave under partial dataset availability?
- What's the latency profile for the p99 case, not just the happy path?

**MCP tools specifically:**
- Under what circumstances should an LLM NOT invoke this tool?
- What does the caller receive if the upstream SongDNA service is degraded?
- How would a future LLM misuse this tool if the description drifted from
  the implementation?

**Cross-dataset consistency:**
- Which of the 14 datasets does this touch, and what happens if one is stale?
- What's the contract if data is inconsistent across datasets?

---

## Session summary

After 2–3 questions, produce a session summary regardless of how the check went.
This closes the unit of work and provides a record of what was consolidated.

```markdown
## Session complete ✓

**Built:** [name of what was implemented]
**ADR:** [ADR number and title, or "not yet committed" if still pending]

### Comprehension check summary

**Probed:**
- [aspect 1]: [deep / shallow + follow-up / gap noted]
- [aspect 2]: [deep / shallow + follow-up / gap noted]
- [aspect 3 if asked]: [deep / shallow + follow-up / gap noted]

### Gaps to carry forward
<!-- Any genuine gaps in understanding surfaced during the check.
     Not failures — just things to keep in mind for the next unit of work. -->
- [gap, if any — or "none identified"]

### Before moving on
- [ ] ADR committed to DECISIONS.md alongside implementation
- [ ] Open questions from ADR resolved or explicitly deferred
- [ ] Any gaps above noted for follow-up

---
Ready for the next unit of work.
```

---

## Tone calibration

The check should feel like a senior engineer doing a knowledge transfer
conversation, not a performance review. Calibrate based on the developer's
responses:

**If responses are deep and confident:** move through questions quickly,
validate, and clear them promptly. Don't manufacture doubt.

**If responses are shallow but engaged:** ask the follow-up, give them
a chance to go deeper. Most shallow responses just need one more prompt.

**If the developer is clearly tired or frustrated:** shorten the check
to one question on the highest-priority tradeoff, note it in the summary,
and clear them. A resentful check produces worse outcomes than a short one.

**If the developer pushes back ("I know this, let's move on"):** acknowledge
it, ask one question anyway — the single highest-priority tradeoff from the
ADR — then clear them regardless of the answer. The act of asking once is
enough to trigger reflection even if the response is brief.

Never make the developer feel judged. The check exists to serve their
understanding, not to evaluate them.
