# Skill: ss-fix

Generate a bug fix record for a confirmed bug. This is a single lightweight doc that combines investigation, scoping, and fix into one artifact. It begins with diagnosis and ends with a record of what changed and what tests were added.

---

## When to Use

- A bug has been reported or discovered
- An existing feature is behaving incorrectly
- A regression has been introduced

Do not use this skill for new features or planned changes. Use the `ss-spec` skill instead.

---

## Inputs

| Input | Required | Description |
|---|---|---|
| Bug description | Yes | How the bug manifests. Steps to reproduce if known. |
| Environment | No | Where the bug was observed — prod, staging, local, specific version |
| Reporter | No | Who found it — human, agent, test suite, monitoring |
| Relevant feature spec | No | `spec.md` for the affected feature if it exists |

Before writing, read:
1. The affected code
2. The existing test suite for the affected area
3. The feature `spec.md` if one exists — to understand original intent

---

## Output

```
bugs/{NNN}-{short-description}.md
```

Where `{NNN}` is the next available bug ID.

---

## Steps

### 1. Investigate First, Write Second

Do not begin writing the fix record until the root cause is confirmed. Investigation comes first:

1. Reproduce the bug
2. Identify the root cause — not the symptom
3. Determine blast radius — what else is affected
4. Write additional test cases that expose the bug before applying the fix
5. Apply the fix
6. Confirm all tests pass including new cases

The fix record documents what happened during investigation. It is not a plan.

---

## Template

```markdown
# Bug Fix: {Short Description}

| Field | Value |
|---|---|
| id | {NNN} |
| status | fixed |
| created | {date} |
| reporter | {human | agent | test suite | monitoring} |
| environment | {where observed} |
| affected-feature | {feature name or spec ID if known} |

---

## Context <!-- required -->

{How and where this bug was discovered. What behaviour was observed versus what
was expected. Include reproduction steps if they were needed to confirm the bug.}

---

## Problem Scope <!-- required -->

### Root Cause <!-- required -->

{The actual cause of the bug, not the symptom. One or two sentences. If the
root cause could not be fully determined, say so and explain what was confirmed.}

### Blast Radius <!-- required -->

{What is affected by this bug. Users, features, downstream systems, data
integrity. Rate severity:}

**Severity:** {Critical | High | Medium | Low}

- Critical — data loss, security issue, or complete feature failure
- High — significant feature degradation affecting most consumers
- Medium — partial or edge case failure with a workaround
- Low — cosmetic or negligible impact

### Spec Gap <!-- optional -->

{Did this bug exist because the original spec missed an edge case, made a wrong
assumption, or was ambiguous? If yes, describe the gap. This is a candidate for
a spec revision.}

---

## Fix Applied <!-- required -->

### What Changed <!-- required -->

{Description of the fix. What was wrong, what was changed, and why this change
corrects the root cause rather than masking the symptom.}

### Test Cases Added <!-- required -->

{List the new test cases written to expose this bug. These must be written
before the fix is applied and must fail before / pass after.}

- `{test name}` — {what it validates}

### Test Evidence <!-- required -->

{Actual test output showing new and existing tests passing after the fix.}

\`\`\`
{test output}
\`\`\`
```

---

## Completion Criteria

- [ ] Root cause identified and confirmed, not just symptom described
- [ ] Blast radius assessed with severity rating
- [ ] New test cases written before fix was applied
- [ ] Test evidence is actual output, not a summary
- [ ] Spec gap noted if one was found
- [ ] Status set to `fixed`

---

## Next Steps

1. Human reviews fix record
2. If a spec gap was identified, assess whether `spec.md` needs revision
3. If severity was Critical or High, consider whether related areas need audit
