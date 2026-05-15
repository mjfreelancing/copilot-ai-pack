---
applyTo: "**/e2e/**"
---

# Playwright E2E Instructions

## Core Rules

### Locator and Click Strategy

- Prefer user-facing locators in this order: `getByRole` -> `getByLabel` -> `getByText` -> stable test id.
- If reliable locators are missing, suggest minimal product-code improvements that strengthen testability (for example accessible names/roles or stable `data-testid` attributes).
- When in scope, implement those locator improvements in product code with minimal surface-area changes; when out of scope, record the recommendation with rationale.
- Use CSS/xpath locators only when no accessible locator exists.
- Click actionable controls directly; avoid clicking container wrappers when a child control is available.
- Scope locators to a stable region/dialog before clicking to reduce ambiguity.
- Do not use forced clicks unless the test explicitly validates blocked/hidden interaction behavior.

### Click Reliability

- For Playwright test code, prefer `await locator.click()` over coordinate clicks.
- Assert outcome immediately after click (URL, dialog, network response, or UI state change).
- Do not chain ambiguous clicks without assertions between them.
- For controls that open overlays, assert the overlay role/heading before continuing.

### Assertions and Waiting

- Use web-first assertions (`toHaveText`, `toContainText`, `toHaveURL`, `toHaveCount`) instead of manual polling.
- Rely on Playwright auto-waiting; do not add hard sleeps for synchronization.
- Use visibility assertions only when visibility itself is the behavior under test.
- When UI values are API-driven, assert from intercepted response payloads where practical.

### Test Structure and Readability

- Group tests by user behavior and feature intent.
- Use descriptive test titles that read as behavior statements.
- Keep each test focused on one user journey outcome.
- Add comments only for non-obvious setup or complex assertions.

### Stability and Determinism

- Avoid selectors tied to styling classes, animation classes, or fragile DOM structure.
- Avoid assumptions about timing/order across parallel workers.
- Keep tests independent from prior test data unless a fixture explicitly defines shared setup.
- Prefer deterministic fixture setup over in-test ad hoc data mutation.

### Browser Tooling Interactions

- For browser-driven exploration with `mcp_microsoft_pla_browser_click`:
  - Capture a fresh page snapshot before targeting an element.
  - Use exact target references from the snapshot when available.
  - Provide a human-readable `element` description that reflects user intent.
  - Re-snapshot after significant click-driven UI changes to avoid stale references.

## Expansion Notes

- Keep reusable Playwright guidance above in Core Rules.
- Keep project-specific route anchors, selector anchors, fixture contracts, and run commands below.
