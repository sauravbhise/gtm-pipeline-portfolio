# Decisions Log

Running record of key decisions and tradeoffs made on this project, and why. Kept honest and dated — this is as much a portfolio artifact as the code itself (shows real engineering judgment, not just output).

---

## 2026-08-16 — Capstone project selection

**Decision:** Build the GTM/AI automation capstone for my father's sheet-metal stamping business, instead of a generic/fictional SaaS demo.

**Why:** Real stakeholder, real constraints, real outcome — a stronger story for job interviews and MBA essays than a synthetic demo. Manufacturing GTM is also a genuine niche few candidates in this space have touched.

---

## 2026-08-16 — Specific vs. generic build

**Decision:** Build the pipeline fully specific to the stamping business (fields, ICP, prompts, schema) rather than designing an abstract/reusable tool from day one.

**Alternatives considered:** Generic, configurable pipeline that could serve any manufacturing client.

**Why:** Premature genericity adds complexity with no current payoff. Easier to abstract a working specific system later than to design abstract-first and hope it fits. A working specific system is also stronger proof than an unproven generic claim.

---

## 2026-08-16 — Core tool stack

**Decision:** n8n (orchestration) + Clay (enrichment) + LLM API — Claude/OpenAI (personalization) + HubSpot (CRM), rather than building custom equivalents for any of these.

**Why:** These are the tools GTM engineering job descriptions actually reference. Building custom enrichment/CRM would be a worse use of limited time and wouldn't match what employers expect candidates to already know.

---

## 2026-08-16 — Intake questionnaire delivery

**Decision:** Primary path — n8n Form Trigger writing to Airtable/Sheets, self-hosted. Fallback — Google Form → Sheets if the VM isn't live within 2-3 days.

**Alternatives considered:** Google Forms, Microsoft Forms, Tally.so, Airtable Forms.

**Why:** n8n's own form-builder means the very first artifact of this project is already part of the automation pipeline, not a throwaway step before it — doubles as Phase 1 practice (trigger + branching logic) from the upskilling roadmap. Decoupled explicitly from the VM timeline so the business-facing questionnaire never blocks on my own infra learning curve.

---

## 2026-08-16 — Exposing self-hosted n8n to the internet

**Decision:** Free-tier cloud VM (always-on), not Cloudflare Tunnel or ngrok.

**Alternatives considered:**

- Cloudflare Tunnel — free, no port-forwarding, but requires my laptop to stay on and running
- ngrok/localtunnel — fast but rotating URLs on free tier, unsuitable for sharing with a non-technical recipient over several days

**Why:** The intake form is step one of a longer-lived pipeline (Clay → n8n → LLM → HubSpot) that needs a permanent home regardless. Doing the VM setup now avoids redoing infra work later in the roadmap. Chosen deliberately as a skill-building opportunity, not just the path of least resistance — self-hosting/infra ownership is a stated personal differentiator for GTM-engineer positioning.

---

## 2026-08-16 — Additional infra components (database, self-hosting scope)

**Decision:** Keep the stack minimal — n8n with its default SQLite backend; intake data stays in Airtable/Sheets rather than a self-hosted Postgres instance. Clay and HubSpot remain managed SaaS (not self-hosted alternatives).

**Why:** Self-hosting a database adds real ongoing maintenance (backups, patching, security) for no current benefit. Revisit only if/when the simple version's limits are actually felt.

---

## 2026-08-16 — Local development vs. building directly on the VM

**Decision:** Build and test n8n workflows on a locally-hosted instance; export as JSON and import to the VM only once a workflow is working.

**Why:** Faster iteration without SSH round-trips while still figuring out logic. Decouples workflow-building progress from VM/networking progress — if Oracle provisioning is slow or blocked, roadmap work continues regardless. Also mirrors standard dev → prod practice already familiar from CI/CD work.

---

## 2026-08-16 — Repository structure

**Decision:** Single monorepo (`gtm-ai-automation-portfolio`) rather than separate repos per component.

**Why:** No independent-team access-control need, no reusable-library case for separate repos. A single repo is also simpler to point recruiters/interviewers/admissions readers at — one link, one README, one coherent story.

---

## 2026-08-16 — VM / cloud provider selection

**Decision:** Attempt Oracle Cloud "Always Free" ARM tier first, time-boxed to ~1 day of provisioning attempts (including retrying regions if "out of capacity" errors occur). Fallback to GCP's e2-micro (also free-forever) if Oracle isn't resolved in that window.

**Alternatives considered:**

- **GCP e2-micro** — reliable signup, no capacity roulette, but only ~1GB RAM (tight for future growth)
- **AWS / Azure** — free tier is a 12-month window only, then bills at standard rates; wrong shape for a "forever free" build
- **Hetzner** — not free, but ~$5/mo removes every free-tier caveat; kept as a mental fallback if both free options fail
- **Railway / Render / Fly.io (PaaS)** — fastest to deploy, but less infra-ownership learning value and free tiers often cold-start/sleep

**Why:** Oracle offers meaningfully more headroom (2 OCPU/12GB, vs GCP's ~1GB) for growing the pipeline on one box later, and the extra setup friction is treated as a feature, not a bug, given the stated goal of building genuine infra/self-hosting skill as a differentiator. Time-boxed explicitly so a stuck Oracle provisioning attempt can't stall the whole project — GCP is right there as a real, not hypothetical, fallback.

---

## 2026-08-16 — Build-in-public timing

**Decision:** Log progress privately (not published) for now. Revisit going public in 3–4 weeks once there's real, demoable progress — and once it's clear what needs anonymizing given this touches a real family business.

**Why:** Currently employed full-time; premature public posting about a career pivot risks unwanted attention at the current job. Also need to think through what's safe to share publicly about a real company's operations before anything goes live. The habit (private logging) is what compounds — audience can be added later without cost.

---

## 2026-08-17 — Oracle Cloud attempt and pivot to GCP

**Decision:** Abandoned Oracle Cloud "Always Free" after three separate, unrelated failures during signup/provisioning; moved to GCP's e2-micro (also free-forever) instead.

**What happened, in order:**

1. **Billing-address verification failure** — Oracle repeatedly rejected a billing address that matched the card issuer's records exactly, a known and commonly-reported issue with no reliable single fix (tried reformatting state name, disabling autofill — didn't resolve it).
2. **Client-side signup bug** — after resolving the billing prompt, the "Start My Trial" flow hung on a spinner; network logs showed a CORS error and a blocked request (`ora_code.js`) on Oracle's own signup script, unrelated to anything on my end.
3. **Known capacity risk, never even reached** — researched best-odds regions (Singapore, Frankfurt) in case provisioning itself also failed, but didn't get that far given the above.

**Why give up rather than push through:** The original case for Oracle was more RAM/OCPU headroom (2 OCPU/12GB vs GCP's ~1GB) in exchange for accepting more setup friction as a deliberate skill-building tradeoff (see 2026-08-16 VM provider entry). That tradeoff assumed the friction would be _capacity-related_ — a known, bounded risk we'd already planned around. Instead the failures were pre-provisioning, on Oracle's own signup infrastructure, with no clear resolution path and no way to know if a fourth attempt would succeed. Continuing to debug someone else's broken signup flow stopped being "infra-ownership skill-building" and became pure sunk-cost risk with no learning value. GCP was the pre-agreed fallback for exactly this scenario (see 2026-08-16 provider selection entry) — used as intended rather than reactively.

**Outcome:** GCP e2-micro provisioned successfully via Terraform (see `infra/`) on first attempt, `us-central1-c`, no capacity or billing issues encountered.

**Worth keeping in mind going forward:** the ~1GB RAM ceiling this accepted is fine for the current plan (n8n only, everything else stays managed SaaS per the 2026-08-16 "additional infra components" decision) — but is the thing most likely to force a future migration if the pipeline ever needs to run more on-box.

---

## 2026-08-21 — Generalized question wording over company-specific phrasing

**Decision:** Reworded all questionnaire fields to be generic/reusable (e.g., "Is it still accurate that your tool room handles X" → neutral phrasing with the known answer moved into `defaultValue`), rather than writing questions specific to Atharva Metals.

**Why:** Reverses the original "build specific, generalize later" call from 2026-08-16 — worth naming explicitly rather than letting it pass silently. Made the call once the JSON structure was already proven out on Chapter 1, so generalizing cost little and buys real reusability if this pipeline is ever pointed at a different company. Known company-specific facts weren't lost — they moved into pre-filled defaults instead of the question text itself, so the form still shows up "smart" for Atharva without hardcoding the question wording to only make sense for Atharva.

---

## 2026-08-21 — Company Name identifier: Set node vs. hidden form field

**Decision:** Added `Company Name` via a Set/Edit-Fields node hardcoded in each n8n workflow (after the Form Trigger, before Airtable), rather than as a form field (visible or hidden) filled in by the respondent.

**Alternatives considered:**

- Visible text field, retyped by the respondent on each chapter — real risk of inconsistent spelling ("Atharva Metals" vs "Atharva Metals & Engineering") breaking the Airtable match/upsert logic across chapters
- Hidden field pre-filled via URL query parameter, auto-carried between chapters — more "dynamic," reusable across companies without editing the workflow, but requires either manually constructing correct URLs each time or building an auto-generate-next-link step

**Why:** For a single-respondent, single-company use case, hardcoding in the workflow is simpler and more reliable than trusting free-text consistency across 4 separate sessions. Reusing this for a future company only costs a 10-second edit to the Set node's value — not real friction. The query-parameter approach was consciously deferred rather than rejected: worth building once there's a second real company to justify the extra plumbing, not speculatively now.

---

## 2026-08-21 — Airtable: single consolidated table + CSV-import scaffolding

**Decision:** All 4 chapters write into one Airtable table (`Company Profiles`, `Company Name` as primary/match field) rather than 4 separate tables — consistent with the earlier "one company = one row, not four sparse tables" reasoning. Table structure (79 columns) was scaffolded via CSV import rather than manually creating every field through the UI.

**Why single table:** Same logic as the original repo-structure and questionnaire-delivery decisions — one respondent, one evolving profile, not a many-respondent system that would benefit from relational separation. Four filtered Views (one per chapter) keep the wide table readable without duplicating data across tables.

**Why CSV import:** Manually creating 79 fields one at a time through Airtable's UI is slow and error-prone at this scale. A CSV with all column headers plus one flagged sample row lets Airtable bulk-create every field in one import, at the cost of a manual follow-up pass converting text fields to the correct Single/Multiple Select types and re-adding their option lists — CSV import can't reliably set those. Net faster than building by hand despite the follow-up work.

---

## 2026-08-16 — Time estimate: build vs. buy (infra vs. questionnaire tool)

**Decision:** Treat the questionnaire delivery and the VM/pipeline infra as two independently-paced tracks rather than one bundled effort.

**Why:** The questionnaire's job is to get real data from the business, ideally on a short timeline; the VM's job is to be the long-term home for a capstone with no hard deadline. Bundling them means the business waits on my personal infra learning curve — wrong dependency direction. Explicitly decoupled with a 2-3 day fallback trigger (see questionnaire delivery decision above).
