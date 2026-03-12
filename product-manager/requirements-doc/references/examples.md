# Approved Output Examples — requirements-doc

This file is maintained automatically. When the user approves an output as
good, Claude appends it here under a dated heading. Future sessions use these
as style and quality references.

---

<!-- Approved examples will appear below this line -->

---

## 2026-03-10 — Internal Expense Reporting Tool PRD (Approved)

Context: Large PRD with 5 major sections (submission flow, approval flow, notifications, finance export, admin controls). Three user types: Employee, Manager, Finance Admin. Drafted using parallel subagent approach per skill instructions.

Key style notes from this approved output:
- Problem statement leads with the user's experience, not the product's features — no feature language in the first paragraph
- Non-goals include brief rationale ("deferred to v2; X reason") rather than bare bullets
- Decisions Log always captures the "why" column — outcome alone is not sufficient
- Open Questions table uses a blocking Y/N column and assigns an owner role (not a person) since individuals weren't named
- Mandatory UX decisions from design critique (rejection reason field, auto-save) appear in both the Decisions Log and the relevant Functional Requirements section — they are cross-referenced, not siloed
- Assumptions section explicitly flags items that need validation before launch (legal sign-off on retention period)

```markdown
# Internal Expense Reporting Tool — Product Requirements Document
Version: v0.1
Date: 2026-03-10
Status: Approved

---

## Problem Statement

Employees have no structured way to submit business expenses — they email receipts as attachments and wait while finance teams manually reconcile them in spreadsheets. This process is slow, error-prone, and produces no reliable audit trail, leaving employees uncertain about reimbursement status and finance teams spending disproportionate time on administrative data gathering instead of financial oversight.

---

## Goals

What success looks like for v1. Keep to 3-5 items maximum.

- **Structured submission** — Employees can capture, categorise, and submit receipts in one flow, eliminating email handoffs and lost attachments
- **Clear approval workflow** — Managers can review, approve, or reject expenses with context, replacing ad-hoc threads and giving submitters actionable feedback
- **Finance export** — Finance admins can export approved expenses by period to CSV, providing a clean reconciliation input without manual data gathering
- **Compliance-ready storage** — Receipts are retained for 7 years automatically, meeting audit requirements without manual archiving
- **Status visibility** — Employees and managers can see where any expense stands without chasing each other

---

## Non-Goals

What this product explicitly does NOT do in v1.

- Direct QuickBooks / Xero / accounting system integration — CSV export covers the v1 reconciliation need; full integration adds auth and mapping complexity best addressed in v2
- Multi-currency support — deferred to v2; single-currency keeps submission and approval logic simple for v1
- Bulk approval — deferred to v2; individual review supports audit trail requirements and reduces rubber-stamping risk
- Native iOS / Android app — mobile-first web covers the v1 submitter need without app store overhead or separate release cycles
- Multi-level or custom approval chains — single manager approval is sufficient for v1; escalation paths can be added in v2
- Email notifications — Slack covers the manager notification path; in-app covers the employee path for v1

---

## Users

**Employee (Submitter):** An employee who has incurred a business expense and needs reimbursement. They are frequently away from a desk — at client sites or in transit — and access the tool via a mobile browser immediately after a purchase to capture the receipt before losing it. Their goal is to submit quickly, with confidence that their draft is safe and that they will know when the expense is resolved.

**Manager (Approver):** A people manager responsible for approving direct reports' expense claims. They review expenses from a desktop browser, typically in batches, and are notified via Slack when a submission arrives. Their goal is to process legitimate claims quickly and give clear, actionable feedback when rejecting.

**Finance Admin:** A member of the finance team responsible for reconciling approved expenses by period. They work from a desktop browser and need a reliable CSV export that requires no manual reformatting before loading into their reconciliation workflow. They also need access to receipts for audit purposes.

---

## Functional Requirements

### Expense Submission

- **Must:** Employee can upload a receipt (image or PDF)
- **Must:** Employee must select a category for the expense (category list to be confirmed with finance — see Open Questions)
- **Must:** Employee can add a free-text note to the submission
- **Must:** Drafts are auto-saved continuously — no manual save action required
- **Must:** Employee can submit the expense for manager review
- **Must:** Employee can view the current status of all their submitted expenses (pending, approved, rejected)
- **Should:** Employee receives an in-app notification when their expense status changes
- **Won't:** Employee can submit in multiple currencies — deferred to v2

### Approval Workflow

- **Must:** Manager receives a Slack notification when a direct report submits an expense
- **Must:** Manager can view the receipt and all submitted details before deciding
- **Must:** Manager can approve an expense
- **Must:** Manager can reject an expense; a written reason is required — the rejection reason field is mandatory
- **Must:** Approval or rejection updates the expense status immediately and notifies the submitter
- **Should:** Manager can view all pending expenses for their direct reports in a single list
- **Won't:** Manager can bulk-approve multiple expenses in one action — deferred to v2

### Finance Export

- **Must:** Finance admin can filter approved expenses by date range
- **Must:** Finance admin can export the filtered set to CSV
- **Must:** CSV includes: submitter name, submission date, category, amount, notes, approval date, approver name
- **Should:** Finance admin can additionally filter by employee, department, or category before exporting
- **Won't:** Direct push to QuickBooks, Xero, or any accounting system — deferred to v2

### Notifications

- **Must:** Manager receives a Slack notification on each new employee submission
- **Should:** Employee receives an in-app notification on approval or rejection
- **Won't:** Email notifications in v1 — Slack covers the manager path; in-app covers the employee path

### Receipt Storage

- **Must:** Uploaded receipts are stored and retrievable for a minimum of 7 years
- **Must:** Receipts are accessible to finance admins for audit purposes throughout the retention period
- **Should:** Receipt storage is access-controlled — submitter, approver, and finance admin can access; no broader access

### Admin Controls (Finance Admin)

- **Must:** Finance admin can view all approved expenses across the organisation
- **Must:** Finance admin can access receipts attached to any expense record
- **Should:** Finance admin can see an approval audit log (approver name, action, timestamp) for each expense
- **Won't:** Finance admin can re-open or override an approved expense in v1 — behaviour needs more definition; deferred to v2

---

## Decisions Log

| Decision | What was decided | Rationale |
|---|---|---|
| Submitter interface | Mobile-first web | Employees capture receipts immediately after purchase; mobile-first reduces friction at the point of need without the overhead of a native app |
| Manager notifications | Slack only | Managers are already active in Slack; adding email or in-app notifications for managers increases noise without benefit in v1 |
| Finance export format | CSV only, no direct accounting integration | CSV covers the reconciliation need for v1 and avoids the auth and field-mapping complexity of QuickBooks/Xero integration; full integration is a clear v2 item |
| Receipt retention | 7 years | Compliance requirement; auto-retention removes the manual archiving burden from the finance team |
| Rejection UX | Mandatory rejection reason field | Raised and resolved in design critique — without a required reason, rejected submitters have no clear path to correct and resubmit; the field is mandatory, not optional |
| Draft saving | Auto-save only, no manual save button | Raised in design critique — a manual save button created uncertainty about whether in-progress work was captured; auto-save eliminates that ambiguity |
| Approval chain depth | Single manager approval | Multi-level approval routing adds complexity not warranted for v1; escalation paths and custom chains are a v2 item |
| Multi-currency | Out of scope for v1 | Adds significant UX and reconciliation complexity; deferred until there is demonstrated demand from users |
| Bulk approval | Out of scope for v1 | Individual review supports audit trail integrity; bulk approval risks rubber-stamping and is better addressed in v2 with appropriate safeguards |

---

## Open Questions

| Question | Blocking? | Owner |
|---|---|---|
| What expense categories will finance require on the submission form? | Yes — needed before the submission form can be built | Finance team |
| How is the manager relationship established — is there an HR system or directory to pull from, or does it need to be configured manually? | Yes — needed for Slack notification routing | Engineering / HR |
| What Slack workspace and bot permission scopes are available? | Yes — needed for notification implementation | Engineering |
| Should the 7-year retention period be confirmed with legal before launch? | Yes — compliance assumption; needs legal sign-off | Legal / Finance |
| Should employees also receive Slack notifications, or in-app only? | No — in-app is the v1 decision; revisit based on adoption data | Product |
| Who provisions finance admin accounts — self-service, IT, or a super-admin? | No — affects onboarding but not core product flows | Product / IT |
| What receipt file formats and size limits should be enforced? | No — reasonable defaults can be set and adjusted post-launch | Engineering |

---

## Out of Scope (v2+)

- Direct QuickBooks / Xero / accounting system integration — CSV export covers v1; full integration deferred
- Multi-currency support — adds UX and reconciliation complexity; deferred until demand is established
- Bulk approval — individual review preferred for audit trail in v1; revisit with safeguards in v2
- Native iOS / Android apps — mobile-first web covers v1; native apps are a v2 consideration if adoption warrants
- Multi-level or custom approval chains — single manager approval sufficient for v1
- Email notifications — not needed given Slack (managers) and in-app (employees) coverage in v1
- Finance admin ability to re-open or override approved expenses — behaviour definition deferred to v2

---

## Assumptions

- Every employee has exactly one manager in the system — the approval routing assumes a flat, single-level reporting relationship; edge cases (contractors, matrix reporting) are not handled in v1
- The organisation uses Slack and managers can receive direct messages from a bot — if Slack is not universal, the notification strategy will need to be revised before launch
- Receipt uploads will be standard image formats (JPEG, PNG) or PDF; unusual formats are not a v1 concern
- Finance admins will process CSV exports manually in a spreadsheet; no automated pipeline ingestion is expected in v1
- 7-year retention is the applicable compliance period — this must be confirmed with legal before launch (see Open Questions)
- Amounts are entered in a single currency; currency handling is out of scope for v1
```
