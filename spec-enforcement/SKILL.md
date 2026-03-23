---
name: spec-enforcement
description: >
  Enforce a structured spec before any code is written during AI-assisted development.
  Use this skill whenever a developer is about to ask an agent to implement something —
  a new function, module, MCP tool, API endpoint, schema change, or any other meaningful
  unit of work. Trigger immediately when you see intent to build something without a spec
  present: phrases like "implement X", "add a tool for Y", "build me Z", "write the code
  for", or "let's start on". Do not let implementation begin until the spec is complete
  and validated. If the developer resists, explain that the spec IS the first phase of
  implementation — not a prerequisite to it.
---

# Spec Enforcement

Gates implementation behind a completed, validated spec. The goal is not documentation
for its own sake — it's to ensure the developer has thought through the design before
handing off to an agent. The act of completing the spec IS the design work.

## Core behavior

1. When implementation intent is detected, check whether a completed spec is present in
   the conversation or attached context.
2. If no spec is present, present the template below and block. Do not write code.
3. If a spec is present but incomplete, ask targeted clarifying questions for each gap.
   Do not fill in missing fields yourself — ask the developer to fill them in.
4. Once the spec is complete, validate it against the checklist below before proceeding.
5. Confirm spec acceptance explicitly: "Spec looks complete. Ready to move to planning?"

**Never assume. Never fill in blanks. Always ask.**

---

## Spec template

Present this to the developer when no spec is found. They fill it in; you validate it.

```markdown
# Spec: [name of the thing being built]

## Objective
<!-- One paragraph. What exists after this is done and why it matters.
     Must answer: what problem does this solve? who benefits? -->


## Scope

**In scope:**
-

**Out of scope:**
-

## Interface definition
<!-- Adapt this section to the type of work being done. Examples below. -->

### For MCP tools
- **Tool name:** `tool_name`
- **Description:** (write this as if prompting an LLM — it determines when the tool
  is invoked)
- **Input schema:**
  ```typescript
  {
    field_name: type  // description, validation rules
  }
  ```
- **Output shape:**
  ```typescript
  {
    field_name: type
  }
  ```
- **Error cases:**
  | Condition | Behavior |
  |-----------|----------|
  |           |          |

### For functions / modules
- **Signature:** `functionName(param: Type): ReturnType`
- **Side effects:** none / [describe]
- **Dependencies:** [existing modules this relies on]

### For API endpoints
- **Method + path:** `POST /resource`
- **Request body:**
- **Response shape:**
- **Auth required:** yes / no
- **Error responses:**

## Code style examples
<!-- 2–3 short snippets from the existing codebase showing conventions this
     implementation must follow. Error handling pattern, logging style, test
     structure, async patterns, etc. Pull from real files. -->

### Error handling
```[language]
// example from: src/path/to/file.ext
```

### Test structure
```[language]
// example from: src/path/to/file.test.ext
```

### [Other relevant pattern]
```[language]
// example from: src/path/to/file.ext
```

## Testing requirements
<!-- Not test cases — those come later. These are the requirements tests must satisfy. -->

- [ ] Unit tests required: yes / no
- [ ] Integration tests required: yes / no
- [ ] What must be tested: [list the behaviors, not the implementation]
- [ ] Testing patterns to follow: [e.g. "follow the pattern in src/tools/existing.test.ts"]
- [ ] Coverage expectations: [e.g. "all error cases must have explicit test coverage"]

## Phases
<!-- Only include this section for complex tasks. Delete if the task is a single unit.
     Each phase should be implementable and reviewable independently. -->

### Phase 1: [name]
**Goal:** [one sentence]
**Complete when:** [observable criterion — not "when it's done"]

### Phase 2: [name]
**Goal:** [one sentence]
**Complete when:** [observable criterion]

## Open questions
<!-- Explicit parking lot for things not yet known. Honest about assumptions. -->

- [ ] [Question that needs answering before or during implementation]
```

---

## Validation checklist

Before accepting a spec as complete, verify every item below. If any fail, ask the
developer to address them — do not proceed.

**Objective**
- [ ] Written in plain language (no jargon as a substitute for clarity)
- [ ] States the problem being solved, not just the solution
- [ ] A new engineer could read this and understand why it's being built

**Scope**
- [ ] At least one explicit out-of-scope item (if nothing is out of scope, the scope
      is probably too vague)
- [ ] Out-of-scope items are specific, not generic ("not handling pagination" not
      "not handling edge cases")

**Interface definition**
- [ ] All input fields have types and validation rules, not just names
- [ ] All error cases are explicitly listed with expected behavior
- [ ] For MCP tools: the description is written precisely enough that an LLM would
      invoke the tool in the right cases and not invoke it in the wrong cases

**Code style examples**
- [ ] At least one error handling example from the actual codebase
- [ ] At least one test structure example from the actual codebase
- [ ] Examples are from real files, not invented

**Testing requirements**
- [ ] Specifies *what* must be tested (behaviors), not *how* (implementation)
- [ ] References an existing test file as a pattern to follow

**Phases** (if present)
- [ ] Each phase has a concrete, observable completion criterion
- [ ] Phases are ordered so each can be reviewed independently
- [ ] No phase depends on a future phase to make sense

**Open questions**
- [ ] Any assumption that could be wrong is listed as an open question
- [ ] No open questions that are actually blockers (those should be resolved first)

---

## Clarifying questions by section

Use these when a section is present but incomplete. Ask only the questions relevant
to the gaps — don't run through the whole list.

**Objective is vague:**
- "What specifically will be different after this is built?"
- "Who is the consumer of this — another service, an LLM, a human?"
- "What breaks or stays manual if this doesn't get built?"

**Scope boundary is missing:**
- "What's the closest related thing this will NOT do?"
- "Is [related feature] in scope or explicitly out?"

**Interface is underspecified:**
- "What happens if [field] is missing from the input?"
- "What does the caller receive if [error condition] occurs?"
- "For MCP: in what situation should an LLM NOT invoke this tool?"

**Code style examples are missing:**
- "Can you point me to an existing file that handles errors the way this should?"
- "Is there an existing test file that shows the pattern to follow?"

**Testing requirements are vague:**
- "Which behaviors specifically need test coverage — not just the happy path?"
- "Are integration tests expected, or unit tests only?"

**Phases are missing for a complex task:**
- "This looks like it has multiple distinct parts. Should we break it into phases
   so each can be reviewed independently?"
- "What's the smallest slice of this that would be useful on its own?"

---

## Handoff output

Once the spec is validated, produce this summary to pass into the planning phase:

```markdown
## Spec accepted ✓

**Building:** [name]
**Objective:** [one-sentence summary]
**Interface:** [key signature or tool name]
**Phases:** [n phases / single unit]
**Open questions to resolve during implementation:** [list or "none"]

Ready for planning. The spec above is the source of truth — any implementation
decision that contradicts it requires explicit discussion before proceeding.
```

This summary becomes the context header for all subsequent turns in the session.
