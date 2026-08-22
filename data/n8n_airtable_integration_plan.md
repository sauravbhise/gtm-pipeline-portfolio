# n8n → Airtable Integration — Final Implementation Plan (Order-Independent)

All 4 chapter workflows use the **identical structure**: Set → Airtable (Create or Update). n8n's Airtable node has a native "Create or Update Record" operation (upsert) that handles the match/create/update logic in one node — no manual Search → If → branching required. This means any chapter can be filled first — there's no dependency on Chapter 1 running before the others. Only the field-mapping table differs per chapter.

**Reminder for every workflow you touch:** n8n 2.x separates Save from Publish. Saving keeps edits in draft; the live form URL only reflects your changes after you hit **Publish**. Always publish before testing.

**Also worth a quick check:** n8n preserves each Form Trigger's `webhookId` as-is on import rather than regenerating it. Your 4 chapters were built with distinct IDs, so this shouldn't be an issue — but worth confirming each chapter's production URL actually fires its own workflow (not a neighbor's) once all 4 are live in the same instance.

---

## Step A — Set node (identical in all 4 workflows)

Add immediately after the Form Trigger, before anything else. Configure manually via **+ → search "Edit Fields (Set)"**:

- **Mode:** Manual Mapping
- **Add field:** Name = `Company Name`, Type = String, Value = `Atharva Metals & Engineering`

Same node, same static value, added separately to each of the 4 workflows. The respondent never sees this — it's invisible workflow logic, not a form field. Because every chapter hardcodes the exact same value, the Search step below will always match the right row regardless of which chapter runs first.

*(Equivalent raw config, if you prefer pasting JSON into the node:)*
```json
{
  "parameters": {
    "mode": "manual",
    "assignments": {
      "assignments": [
        {
          "id": "company-name-1",
          "name": "Company Name",
          "value": "Atharva Metals & Engineering",
          "type": "string"
        }
      ]
    },
    "options": {}
  },
  "name": "Set Company Name",
  "type": "n8n-nodes-base.set",
  "typeVersion": 3.4
}
```

---

## Step B — Airtable node: Create or Update (build once, replicate to all 4 workflows)

Add a single Airtable node directly after the Set node. Build and test this fully on whichever chapter you tackle first — the structure is identical for all four, only the field mappings change.

- Credential: your Personal Access Token
- Resource: **Record**
- Operation: **Create or Update**
- Base / Table: your base → `Company Profiles`
- **Columns to Match On:** `Company Name` — this is what tells the node how to find an existing row
- Mapping Mode: Map each column manually (needed regardless, since your Airtable columns are `Ch1 -` prefixed and don't match the form field labels)
- Map `Company Name` (from the Set node), this chapter's completion checkbox → `true`, and every question field per the tables below

Every chapter's workflow ends up with the same 2-node shape after the Form Trigger: **Set → Airtable (Create or Update)**. Since `Company Name` is identically hardcoded across all 4 workflows, the node always matches to the same row regardless of which chapter happens to run first — genuinely order-independent, no branching logic needed.

---

## Chapter 1 field mapping

⚠️ Same caveat as before, unrelated to the order-independence fix: Chapter 1 has 3 fields literally labeled "Others (if any)" and 3 labeled "If Other, please specify." **Submit one real test with distinct values in each duplicate field**, then check the Search/Update/Create node's input panel for the actual key names n8n generated (may be auto-suffixed, e.g. `Others (if any) 1`), and correct the expressions below to match.

| Airtable Column | Form Field Label |
|---|---|
| Company Name | `Company Name` *(from Set node)* |
| Chapter 1 Complete | `true` (literal) |
| Ch1 - Facility size & locations | Facility size & locations |
| Ch1 - Machine Inventory | Machine Inventory |
| Ch1 - Materials & Gauge Range | Materials & Gauge Range |
| Ch1 - Materials, Others | Others (if any) — **1st occurrence** |
| Ch1 - Additional in-house capabilities | Additional in-house capabilities |
| Ch1 - In-house capabilities, Others | Others (if any) — **2nd occurrence** |
| Ch1 - Workforce count (on payroll) | Current total workforce count (On Payroll) |
| Ch1 - Workforce count (incl. contract) | Current total workforce count (incl. contract/shop-floor staff) |
| Ch1 - Monthly production capacity | Monthly production capacity |
| Ch1 - Current Capacity Utilization | ⭐ Current Capacity Utilization |
| Ch1 - Typical lead time | Typical lead time from confirmed order to delivery? |
| Ch1 - Tool room/design still accurate? | Is it still accurate that your tool room handles... |
| Ch1 - If changed, what's different | If that's changed, what's different now?... |
| Ch1 - Minimum order quantity | Do you have a minimum order quantity? |
| Ch1 - Typical MOQ, if any | If yes, what's the typical MOQ?... |
| Ch1 - Quality Certifications | Quality Certifications |
| Ch1 - Quality Certs, Others | Others (if any) — **3rd occurrence** |
| Ch1 - Certifications in progress | Any certifications currently in progress... |
| Ch1 - Certs in progress, Other specify | If Other, please specify — **1st occurrence** |
| Ch1 - Specialized/differentiating equipment | Specialized or differentiating equipment |
| Ch1 - Equipment, Other specify | If Other, please specify — **2nd occurrence** |
| Ch1 - Currently exporting? | Do you currently export? |
| Ch1 - Export/import compliance certs | If exporting, any specific export/import compliance certifications held? |
| Ch1 - Export certs, Other specify | If Other, please specify — **3rd occurrence** |
| Ch1 - Formal vendor-approved status | Are there customers you hold formal vendor-approved status with? |

---

## Chapter 2 field mapping
*(no duplicate field labels — clean 1:1 mapping)*

| Airtable Column | Form Field Label |
|---|---|
| Company Name | `Company Name` *(from Set node)* |
| Chapter 2 Complete | `true` (literal) |
| Ch2 - Who owns BD day-to-day | Who currently owns business development day-to-day? |
| Ch2 - BD owner, Other specify | If Other, please specify |
| Ch2 - CRM/tool used | Is there any tool currently used to track leads or customers? |
| Ch2 - How quotes generated | How are quotes currently generated and sent? |
| Ch2 - Customer comms tracked | How are customer communications currently logged/tracked? |
| Ch2 - Other digital presence | Any other digital presence beyond your website? |
| Ch2 - How prospects find you | How do new prospects usually find you? |
| Ch2 - Inquiries per month | Roughly how many new inquiries/RFQs come in per month? |
| Ch2 - Conversion rate | Roughly what share of those convert into an order? |
| Ch2 - Active pipeline size | Roughly how many active leads/opportunities... |
| Ch2 - Sales cycle length | Typical sales cycle length, first contact to signed order? |
| Ch2 - Required during sales process | What's typically required during the sales process? |
| Ch2 - Pricing model | What's your pricing model? |
| Ch2 - Payment terms | Typical payment terms offered? |
| Ch2 - Pricing flexibility (strategic accounts) | Any pricing flexibility for large/strategic accounts? |
| Ch2 - First inquiry to signed order | ⭐ Walk me through what typically happens... |
| Ch2 - Revenue share, top 2-3 customers | Roughly what share of revenue comes from your top 2-3 customers? |
| Ch2 - Who makes final decision (customer side) | Who typically makes the final decision on the customer's side? |
| Ch2 - Price sensitivity | How price-sensitive are your typical customers? |
| Ch2 - Revenue split by industry | Roughly how does revenue split across industries you serve? |
| Ch2 - Segments deliberately avoided | Are there customer segments you deliberately avoid? |
| Ch2 - Biggest edge over competitors | What's your biggest edge over competitors? |
| Ch2 - Biggest competitors | Who are your 3-5 biggest competitors? |
| Ch2 - What competitors do better | Is there anything they do noticeably better than you? |
| Ch2 - Recent deals lost | Any recent deals lost — to whom, and why? |
| Ch2 - Industry perception | How do you think the industry perceives your company? |

---

## Chapter 3 field mapping
*(no duplicate field labels)*

| Airtable Column | Form Field Label |
|---|---|
| Company Name | `Company Name` *(from Set node)* |
| Chapter 3 Complete | `true` (literal) |
| Ch3 - Check-in cadence | How often do you check in with existing customers? |
| Ch3 - How stay in touch | How do you currently stay in touch with existing customers? |
| Ch3 - Tried upsell/cross-sell | Have you tried offering existing customers more product lines or capacity? |
| Ch3 - If tried, what happened | If tried, what happened? |
| Ch3 - Leads fall through cracks | Do inquiries or leads ever fall through the cracks? |
| Ch3 - Recurring reasons deals lost | ⭐ What are the recurring reasons you tend to lose deals? |
| Ch3 - Deals lost, Other specify | If Other, please specify |
| Ch3 - Biggest bottleneck | ⭐ What's the single biggest bottleneck... |
| Ch3 - Most wasted time | What feels like the most wasted time in your current process? |
| Ch3 - Ideal customer, own words | ⭐ In your own words, what does your ideal customer look like? |
| Ch3 - Companies you'd love to work with | Are there specific companies you'd love to work with... |
| Ch3 - New industries/geographies | Any new industries or geographies you're hoping to expand into? |
| Ch3 - New markets, Other specify | If new export markets or Other, please specify |

---

## Chapter 4 field mapping
*(no duplicate field labels)*

| Airtable Column | Form Field Label |
|---|---|
| Company Name | `Company Name` *(from Set node)* |
| Chapter 4 Complete | `true` (literal) |
| Ch4 - Primary BD/sales decision-maker | Who is the primary decision-maker for BD/sales strategy? |
| Ch4 - Decision-maker, Other specify | If other, please specify |
| Ch4 - KPIs/targets tracked | Are there any KPIs or targets currently tracked for sales/BD? |
| Ch4 - Comfort with digital tools | How comfortable is the team with adopting new digital tools day-to-day? |
| Ch4 - Tried CRM that didn't stick | Have you tried a CRM or similar digital tool before that didn't stick? |
| Ch4 - If didn't stick, what happened | If it didn't stick, what happened? |
| Ch4 - Who would operate it day-to-day | ⭐ Once something like this is built, who would actually use/operate it? |
| Ch4 - Operator, Other specify | If someone else, please specify |
| Ch4 - Open to systematic vs. relationship-driven | ⭐ How open is the team to a more systematic, automated approach? |

---

## One remaining edge case worth knowing (not fixing now)

If two chapters are submitted at nearly the exact same moment, there's a theoretical race condition where both could miss seeing each other's not-yet-committed row and both create separate records instead of one being caught as an update. Given this is a single respondent filling chapters one at a time, not a high-concurrency system, this is a real but extremely low-probability edge case, and it applies to the native Create or Update operation just as it would to a manual pattern. Not worth engineering around now; if it ever happened, the fix is simply merging the two rows manually in Airtable.

---

## Testing checklist, in order

1. Build the Set → Airtable (Create or Update) pattern on **one** chapter (pick any)
2. Publish it, submit a test — confirm it **creates** a new record (since none exists yet) and lands correctly in Airtable, including checking the duplicate-field-name fix if this is Chapter 1
3. Submit a **second** test on the *same* chapter with different answers — confirm it now **updates** the same row (matched on Company Name) rather than creating a duplicate
4. Once confirmed, replicate the identical Set → Airtable (Create or Update) structure to the remaining 3 chapters, swapping in each one's field mapping
5. Test filling chapters in a deliberately mixed order (e.g., Chapter 3 first, then Chapter 1) to confirm everything still lands in one consolidated row regardless of sequence
6. Final check: one Airtable row, all 4 completion checkboxes ticked, all ~73 question columns populated
