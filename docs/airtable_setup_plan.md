# Airtable Setup — Actionable Plan

## Step 0 (blocking — do this first): Add an identifier field to all 4 n8n forms

None of the 4 final forms currently capture a name or company identifier. Without one, there's no way to match a Chapter 2/3/4 submission back to the right Chapter 1 record — Airtable would just get 4 unlinked rows.

**Fix:** Add a single field, first position, in all 4 forms:
- Field label: `Company Name`
- Type: `text`, `requiredField: true`

Since this is a single-respondent flow right now (one company, filled sequentially), simplest approach: they just retype the company name on each chapter — mild friction, zero extra n8n logic. If you want it to auto-carry between chapters instead, that's the query-parameter pre-fill trick from earlier (generate each chapter's link with `?companyname=Atharva+Metals` appended after the previous chapter's submission) — nice-to-have, not required to unblock the Airtable design.

Once this field exists in all 4 workflow JSONs, the rest of this plan works as written.

---

## Step 1: Create the base

New base: **"GTM Intake — [Company Name]"** or a generic **"GTM Company Intake"** if you want one reusable base across future companies (recommended, given the reusability goal). One table inside it: **"Company Profiles"**.

## Step 2: Primary field

- `Company Name` — Single line text — this is the primary field and the match key every chapter's upsert logic searches against.

## Step 3: Supporting/meta fields

| Field | Type |
|---|---|
| Respondent Name | Single line text |
| Chapter 1 Complete | Checkbox |
| Chapter 2 Complete | Checkbox |
| Chapter 3 Complete | Checkbox |
| Chapter 4 Complete | Checkbox |
| Last Updated | Last Modified Time *(native Airtable field, auto-tracked, no setup)* |

## Step 4: Question fields, by chapter

Naming convention: prefix every column `Ch1 -`, `Ch2 -`, etc. — several fields share identical labels across chapters (multiple "If Other, please specify" fields) so this keeps columns unambiguous. Field type mapping: n8n `dropdown` → Airtable **Single select**; n8n `checkbox` → Airtable **Multiple select**; n8n `textarea` → **Long text**; n8n `text` → **Single line text**; n8n `number` → **Number**.

### Chapter 1 — Capabilities & Certifications (25 fields)
1. Ch1 - Facility size & locations — Long text
2. Ch1 - Machine Inventory — Long text
3. Ch1 - Materials & Gauge Range — Multiple select (GL/GPSP; Aluminium 0.25-2mm/coated steel; HR/CR steel up to 16mm; SS304/SS430 up to 2mm; ERW pipes)
4. Ch1 - Materials, Others — Single line text
5. Ch1 - Additional in-house capabilities — Multiple select (Welding; CNC Tube bending; Tool Room; Designing)
6. Ch1 - In-house capabilities, Others — Single line text
7. Ch1 - Workforce count (on payroll) — Number
8. Ch1 - Workforce count (incl. contract) — Single select (50-100 / 101-250 / 251-500 / 500+)
9. Ch1 - Monthly production capacity — Single line text
10. Ch1 - ⭐ Current Capacity Utilization — Single select
11. Ch1 - Typical lead time — Single select
12. Ch1 - Tool room/design still accurate? — Single select
13. Ch1 - If changed, what's different — Long text
14. Ch1 - Minimum order quantity — Single select
15. Ch1 - Typical MOQ, if any — Single line text
16. Ch1 - Quality Certifications — Multiple select (IATF 16949:2016 / ISO 9001:2015 / Other)
17. Ch1 - Quality Certs, Others — Single line text
18. Ch1 - Certifications in progress — Multiple select
19. Ch1 - Certs in progress, Other specify — Single line text
20. Ch1 - Specialized/differentiating equipment — Multiple select
21. Ch1 - Equipment, Other specify — Single line text
22. Ch1 - Currently exporting? — Single select
23. Ch1 - Export/import compliance certs — Multiple select
24. Ch1 - Export certs, Other specify — Single line text
25. Ch1 - Formal vendor-approved status — Long text

### Chapter 2 — Current Business & Process (26 fields)
26. Ch2 - Who owns BD day-to-day — Single select
27. Ch2 - BD owner, Other specify — Single line text
28. Ch2 - CRM/tool used — Single select
29. Ch2 - How quotes generated — Single select
30. Ch2 - Customer comms tracked — Multiple select
31. Ch2 - Other digital presence — Multiple select
32. Ch2 - How prospects find you — Multiple select
33. Ch2 - Inquiries per month — Single select
34. Ch2 - Conversion rate — Single select
35. Ch2 - Active pipeline size — Single select
36. Ch2 - Sales cycle length — Single select
37. Ch2 - Required during sales process — Multiple select
38. Ch2 - Pricing model — Single select
39. Ch2 - Payment terms — Single select
40. Ch2 - Pricing flexibility (strategic accounts) — Single select
41. Ch2 - ⭐ First inquiry to signed order — Long text
42. Ch2 - Revenue share, top 2-3 customers — Single select
43. Ch2 - Who makes final decision (customer side) — Multiple select
44. Ch2 - Price sensitivity — Single select
45. Ch2 - Revenue split by industry — Long text
46. Ch2 - Segments deliberately avoided — Single line text
47. Ch2 - Biggest edge over competitors — Multiple select
48. Ch2 - Biggest competitors — Long text
49. Ch2 - What competitors do better — Multiple select
50. Ch2 - Recent deals lost — Long text
51. Ch2 - Industry perception — Long text

### Chapter 3 — Aspirations & Relationship Management (13 fields)
52. Ch3 - Check-in cadence — Single select
53. Ch3 - How stay in touch — Single select
54. Ch3 - Tried upsell/cross-sell — Single select
55. Ch3 - If tried, what happened — Long text
56. Ch3 - Leads fall through cracks — Single select
57. Ch3 - ⭐ Recurring reasons deals lost — Multiple select
58. Ch3 - Deals lost, Other specify — Single line text
59. Ch3 - ⭐ Biggest bottleneck — Single select
60. Ch3 - Most wasted time — Long text
61. Ch3 - ⭐ Ideal customer, own words — Long text
62. Ch3 - Companies you'd love to work with — Long text
63. Ch3 - New industries/geographies — Multiple select
64. Ch3 - New markets, Other specify — Single line text

### Chapter 4 — Team & Metrics (9 fields)
65. Ch4 - Primary BD/sales decision-maker — Single select
66. Ch4 - Decision-maker, Other specify — Single line text
67. Ch4 - KPIs/targets tracked — Multiple select
68. Ch4 - Comfort with digital tools — Single select
69. Ch4 - Tried CRM that didn't stick — Single select
70. Ch4 - If didn't stick, what happened — Long text
71. Ch4 - ⭐ Who would operate it day-to-day — Single select
72. Ch4 - Operator, Other specify — Single line text
73. Ch4 - ⭐ Open to systematic vs. relationship-driven — Single select

**Total: 73 question fields + 6 meta fields = 79 columns.**

## Step 5: Build 4 Views (not 4 tables)

Wide tables get unreadable fast. Create one filtered/grouped Grid view per chapter:
- **View: "Chapter 1 Fields"** — show only Company Name + the 25 Ch1 columns
- **View: "Chapter 2 Fields"** — Company Name + the 26 Ch2 columns
- **View: "Chapter 3 Fields"**, **"Chapter 4 Fields"** — same pattern
- Optional: a **"Full Profile"** view showing everything, for when you actually want the whole picture at once

Use Airtable's "Hide fields" per view to build these — no data duplication, just different lenses on the same underlying row.

## Step 6: Free tier check

79 columns, 1 row (soon a handful as you test) — nowhere near the 1,000-record cap. Completely fine to build this on free tier as discussed.

## What's next after this is built

Once the table + columns exist, we come back to n8n: wire the Search → If → Update/Create upsert logic into Chapters 2, 3, 4 (Chapter 1 just creates the record, since it's always first).
