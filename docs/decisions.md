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

## 2026-08-16 — Time estimate: build vs. buy (infra vs. questionnaire tool)

**Decision:** Treat the questionnaire delivery and the VM/pipeline infra as two independently-paced tracks rather than one bundled effort.

**Why:** The questionnaire's job is to get real data from the business, ideally on a short timeline; the VM's job is to be the long-term home for a capstone with no hard deadline. Bundling them means the business waits on my personal infra learning curve — wrong dependency direction. Explicitly decoupled with a 2-3 day fallback trigger (see questionnaire delivery decision above).

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

## 2026-08-21 — Duplicate form field labels caused silent data loss (found via testing)

**Decision:** Renamed 6 fields in Chapter 1's form (3x "Others (if any)", 3x "If Other, please specify") to unique labels, after a real test submission proved n8n collapses same-labelled fields into a single JSON key rather than preserving them separately.

**What happened:** Submitted a test through Chapter 1's live form and inspected the actual JSON output rather than assuming how n8n would handle it. The output contained only one `"Others (if any)"` key and one `"If Other, please specify"` key — despite the form having 3 separate fields under each label. n8n overwrites earlier same-labelled field values with later ones when building the submission payload, rather than auto-suffixing or preserving them as an array. The test happened to leave all of these blank, so no real data was lost this time — but had different values been entered in, say, the Materials-Others field and the Quality-Certs-Others field, only one would have survived in the payload, silently.

**Why this matters beyond the immediate fix:** This was flagged as a real risk before building the Airtable field-mapping tables (documented as "verify before trusting this mapping" in the integration plan), but the actual failure mode — silent overwrite, not an error or a warning — is worse than assumed. It would have shipped invisibly; the respondent and I would have no indication data was being dropped unless we happened to inspect the raw payload, which is exactly what testing before wide rollout is for.

**Fix:** Gave each of the 6 fields a unique, descriptive label (e.g., "Others (if any)" → "Materials - Others (if any)" / "In-house Capabilities - Others (if any)" / "Quality Certs - Others (if any)"). This also simplified the Airtable mapping table — no more "1st/2nd/3rd occurrence" caveats, just a direct 1:1 label-to-column mapping.

**Also confirmed via the same test:** Checkbox fields come through as genuine JSON arrays, not comma-separated strings — easier to map directly into Airtable's Multiple Select fields than expected.

**Follow-up:** Chapters 2-4 were checked against their final field lists and appear to have no duplicate labels, but this should still be confirmed with real test output once each is built — reading the JSON is not a substitute for testing it, as this exact case demonstrated.

---

## 2026-08-21 — Airtable integration: native Create-or-Update over manual upsert, plus two bugs caught by testing

**Decision:** Final Airtable integration uses n8n's native "Create or Update Record" (upsert) operation, matched on `Company Name`, rather than a manually built Search → If → Update/Create pattern. Each chapter's workflow is now just Set (Company Name) → Airtable (Create or Update) — 2 nodes instead of 4, same order-independence guarantee (any chapter can run first, all match to the same row).

**Why the simplification happened:** The manual 4-node pattern was built and documented first because the native upsert operation was missed during initial research — pointed out directly, prompting a proper re-check of current n8n/Airtable node capabilities rather than relying on prior assumptions. Confirmed via multiple 2026 sources that Create-or-Update exists and does exactly this. Worth naming plainly: this was a real gap, not a judgment call — the fix was to actually verify rather than assume, which is the same lesson underlying the two bugs below.

**Bug 1 — duplicate form field labels caused silent data loss:** Already logged separately above (Chapter 1's 3x "Others (if any)" / 3x "If Other, please specify" fields collapsing into single overwritten JSON keys). Confirmed fixed via real test submission with distinct values in each field after renaming.

**Bug 2 — Airtable Single/Multi-Select fields created via CSV import had empty option lists:** First surfaced as `expects one of the following values: []` when writing to `Ch1 - Current Capacity Utilization`. Root cause: CSV import creates columns but can't reliably populate select-type option lists — flagged as a known limitation when the CSV approach was chosen, and it materialized exactly as expected. Initial research suggested Airtable's Typecast option (auto-creates missing select options on write) was specifically broken for the Create-or-Update node per multiple open n8n GitHub issues — this turned out to be inaccurate for the actual setup in use: **enabling Typecast resolved the issue directly**, with no further manual option-list population needed. Correcting the record here since the earlier caution (manually populate every select field's options across all 4 chapters) turned out to be unnecessary — a good reminder that community bug reports are signal, not certainty, and a live test outweighs prior research when they conflict.

**Outcome:** All 4 chapters tested end-to-end — form submission → Airtable write — confirmed working, including update-on-resubmit behavior (same row updates rather than duplicating). Order-independence (a chapter other than 1 being filled first) was part of the original design goal but has not yet been explicitly re-confirmed with a live mixed-order test — worth doing before treating this as fully verified.

---

## 2026-08-21 — Apollo.io added as a Clay data provider (not part of original stack)

**Decision:** Using Apollo.io as the underlying data provider for Clay's "Find people at company by job title" enrichment action, on Apollo's free tier, authenticated via a separate API key.

**Why this wasn't planned upfront:** The original tool stack (n8n + Clay + LLM API + HubSpot, decided 2026-08-16) named Clay as the enrichment layer without specifying which of Clay's many underlying data-provider integrations would actually power each enrichment column. Apollo only surfaced once building the real Key Contact column and comparing Clay's available people-search actions — it wasn't a deliberated stack choice, it's an implementation detail one level down from "use Clay."

**Why Apollo specifically:** Of the people-search options surfaced in Clay's enrichment picker, it was the one built for the actual need — filtering people at a given company by job title (Procurement Manager, Sourcing Head, Supply Chain Manager, VP Operations, Plant Head) — rather than a generic contact-list pull requiring manual filtering afterward.

**Cost:** Free tier, no credit card required. Free-tier credit limits are inconsistently reported across sources and not worth treating as precisely known — irrelevant at the current ~11-row shortlist scale regardless of the exact cap. Requires its own API key separate from Clay's own credit balance.

**Worth noting for future reuse:** if this pipeline is ever pointed at a different company/ICP, Apollo access (or its free-tier limits) will need re-verifying — this wasn't a stack decision made with the same scrutiny as the original four tools, just the option that fit the immediate need when building the actual column.

---

## 2026-08-24 — Apollo hit a paid-tier wall; pivoted to Clay-native "Find Contacts at Company"

**Decision:** Replaced the Apollo.io-backed "Find people at company by job title" enrichment column with Clay's own native "Find Contacts at Company" action (~0.5 credits/row), after Apollo's free tier proved unable to run the actual search.

**What happened:** Signed up for Apollo free tier and connected it to Clay via API key, per the 2026-08-21 decision. Running it against the Clay table failed with an explicit error: the specific endpoint Clay's integration calls (`api/v1/mixed_people/api_search`) is not included in the Free plan and requires a paid upgrade. This was a real risk flagged at signup time ("free-tier credit limits are inconsistently reported... worth checking Apollo's own pricing page") — it materialized as a hard capability wall rather than a credit-limit squeeze.

**Why not upgrade Apollo instead:** Checked current Apollo pricing before deciding — sources disagreed on whether full People Search API access starts at the Professional tier (~$79-99/month) or is gated to Organization (~$119-149/month, 3-5 seat minimum), which is itself a signal this is a moving/unclear target not worth paying into speculatively. Paying $50-150+/month to unblock one enrichment column on a project that's otherwise run entirely on free tiers didn't make sense, especially with a genuinely capable free alternative already sitting inside Clay.

**Fix:** Switched to Clay's own native "Find Contacts at Company" action — same underlying goal (title/seniority-filtered contact search per company), but priced against Clay's existing credit balance instead of requiring a separate paid account. Rebuilt the same 7-persona title/seniority/location filter set using Clay's native filter fields (Job Title, Seniority, Job Functions, Location) rather than Apollo's equivalent, and dropped the Company Attributes block entirely since company identity is already fixed per-row in this table (that filter block is meant for open-market search, not row-level enrichment). Tested on the same 3 rows as every other column (Switch Mobility, Tork Motors, Carrier Midea) before running across the full shortlist — confirmed working.

**Worth noting:** This is a second entry in the pattern started with Apollo on 2026-08-21 — a specific data-provider choice made while building, not a top-level stack decision, now reversed once real usage revealed it didn't fit the project's free-tier constraint. The Apollo account and persona-filter research from the broader market-exploration side-project (separate from the Clay shortlist enrichment) remains a valid, working setup on its own — this pivot only affects the Clay-embedded, row-level contact search.

---

## 2026-08-24 — Clay enrichment pipeline complete: Fit Score, Find Contacts, Email Waterfall

**Decision:** Locked the full Clay-side enrichment chain for the prospecting table: Company Search (ICP-filtered) → AI Fit Score → Find Contacts at Company → Email Waterfall. All four stages tested on a small sample before running across the full list, consistent with the testing discipline used throughout the project.

**Fit Score:** Built as a Clay AI column using GPT-4.1 mini (lowest-cost option at 1 credit/row). Tested against known strong/weak fits (Hindware, Carrier Midea vs. Mivi, PEI-Genesis) before trusting it — confirmed real score discrimination (30-93 range) rather than a model defaulting to a safe middle score. Prompt built from a factual Atharva capability description (materials, tonnage, certifications, current customers) plus the "strategic growth partner" framing surfaced from real BDE intake answers ("when he grows, we grow") — this reframing came _after_ initial scoring and is a documented follow-up, not yet re-run into the scores as of this entry.

**Find Contacts at Company:** Originally attempted via Apollo (logged separately, 2026-08-24), hit a paid-tier API wall, pivoted to Clay's own native action. Configured against the 7-persona title/seniority/department filter set developed collaboratively (Procurement, Sourcing/Supply Chain, Operations Director, Plant Head, VP/Head of Manufacturing, Quality Assurance, Design Engineering/NPD) — the Engineering-track persona was added specifically after the BDE's real answer that Procurement _and_ Engineering jointly own the final decision, correcting an initial persona set that under-weighted Engineering.

**Email Waterfall:** 3-provider chain — Findymail (highest accuracy, first position) → Prospeo/Datagma (second) → Hunter (broadest net, final fallback) — deliberately avoiding another BYOK/separate-account dependency after the Apollo lesson; all three run on Clay's native credit balance. Order followed the general "cost control via early cheap/high-coverage provider" principle rather than a fixed accuracy-only ranking, since a full waterfall's cost is dominated by how many rows survive to the more expensive later steps, not the sticker price of any one provider.

**Credit budget checkpoint:** ~1,900 of ~2,005 starting data credits remain after Company Search (2 passes, ~20 rows total), Fit Score (20 rows), Find Contacts, and Email Waterfall (~11-row shortlist). Comfortably within the free trial allocation — no cost pressure to change approach for the remainder of this capstone's Clay usage.

**Still open:** the Fit Score prompt has not yet been re-run with the "strategic growth partner" reframing from the BDE's actual answers — current scores reflect pure capability-matching only. Worth revisiting before treating the current ≥80 shortlist as final.

---

## 2026-08-24 — Deliberate two-pass build: dummy/current data first, BDE-informed re-run as validation

**Decision:** Build the remaining pipeline stages (LLM outreach personalization, HubSpot sync) end-to-end using the current Clay data and pre-refresh Fit Scores, rather than pausing to re-run Fit Scoring with the BDE's "strategic growth partner" framing first. Treat the eventual re-run with corrected/enriched data as a deliberate validation pass, not a rebuild.

**Why:** Consistent with the testing discipline used throughout the project (dummy form submissions before trusting Airtable writes, 2-3 row tests before full runs on every Clay column) — build and confirm the mechanical pipeline works first, then verify it holds up against better inputs, rather than blocking forward progress on a data refresh that doesn't change the pipeline's structure.

**Known costs of this approach, accepted deliberately:**

- LLM personalization API calls (Claude/OpenAI) are pay-per-token, unlike Clay's pooled credit model — building and testing the Outreach Angle step now means paying for those calls twice (once now, once after the Fit Score refresh). Judged acceptable at ~11 rows.
- The shortlist membership may shift once Fit Score is re-run with the growth-partner framing and any BDE-corrected facts — work already done downstream (contacts, emails, draft outreach) for a company that later falls out of the ≥80 threshold becomes throwaway. Acceptable for a capstone/demo; would need real thought before treating this pattern as production-safe with real spend at stake.
  **Requirement this places on the HubSpot sync design:** must use a stable match key (company domain, mirroring the `Company Name` match-key pattern already used for Airtable) so the eventual BDE-informed re-run _updates_ existing HubSpot records via upsert rather than creating duplicates. Building this correctly on the first pass, not deferring it — a re-run that creates duplicate CRM records would undermine the entire point of treating the second pass as validation rather than a fresh start.

**Framing for the portfolio:** the two-pass approach is being treated as a feature to highlight, not a shortcut to hide — demonstrating the pipeline correctly handling a real data refresh (clean upsert, no duplicates, shortlist re-evaluation) is a stronger capstone story than a single clean run would be.

---

## 2026-08-25 — LLM personalization: local model for dev, managed API for deployment (quantified)

**Decision:** Use a self-hosted open-source model (via Ollama) for local development and quality comparison; use a managed API (Claude Haiku 4.5 or GPT-4.1 mini) for the actual deployed pipeline, rather than hosting the LLM on the GCP VM long-term.

**Why self-hosting doesn't make sense for the deployed version, quantified:** At the project's actual scale (~600 input / ~100 output tokens per personalization call), managed API cost is roughly $0.0004-0.0011 per call — 11 calls costs $0.005-0.01 total; even 10,000 calls/month costs $4-11/month. A VM capable of comfortably running a small local model (e2-standard-2, 2 vCPU/8GB) costs a fixed ~$49/month regardless of volume, since the current free-tier e2-micro (~1GB RAM) can't fit even a small quantized model alongside n8n. Break-even point against the managed API is ~45,000-122,000 calls/month depending on model choice — several orders of magnitude beyond anything this project or a realistic near-term production version of it would need.

**Why still build the local version anyway:** Genuine skill-building and portfolio value — Ollama setup, running an OpenAI-compatible local API, and a documented quality comparison against hosted models are real, demonstrable competencies distinct from the deployed architecture decision. No reachability issues either: n8n and Ollama run on the same machine during local dev, so (unlike the Clay→n8n webhook problem) no tunnel is needed for this step.

**Framing:** treated as a deliberate, quantified build-vs-buy call — not a rejection of self-hosting on principle, but a decision backed by real numbers specific to this project's volume, consistent with prior infra decisions (Oracle→GCP, VM sizing for the LLM question) in this log.

---

## 2026-08-25 — n8n hosting: managed self-host over both a DIY VM and n8n Cloud (quantified)

**Decision:** For the final cloud deployment pass, host n8n via a managed self-hosting provider (e.g., PikaPods or OpenHosst, ~$3-7/month, unlimited executions) rather than reviving the GCP e2-micro VM as a DIY-administered server, and rather than n8n Cloud.

**Why not n8n Cloud:** No permanent free tier (confirmed again on re-check). Starter (~$20-24/month) caps at 2,500 executions/month with a hard stop — workflows halt entirely with no overage option until the next billing cycle, a real operational risk distinct from a managed API's smooth linear cost scaling. This project's actual execution volume (intake forms + Clay webhook + downstream steps across ~11-20 rows) is nowhere near that cap even under generous future-growth assumptions, making the cap-and-halt risk pure downside with no corresponding benefit.

**Why not a DIY-managed VM either:** Unlike the LLM hosting question, self-hosting n8n's software is always free — the earlier GCP e2-micro attempt failed on VM sizing (too little RAM), not on the self-hosting model itself. A right-sized DIY VM (e2-standard-2, ~$49/month) would work, but costs 7-16x more than a managed self-hosting option for the same unlimited-execution outcome, with the added burden of server administration (patching, monitoring, uptime) that a managed host absorbs.

**Net effect:** managed self-hosting wins on cost, has no execution ceiling, and avoids both the DIY server-admin burden and n8n Cloud's hard-cap risk — the clear choice at this project's scale, unlike the LLM question where the managed API was the clear winner. Two structurally different "self-host vs. managed" questions in the same pipeline, resolved in opposite directions once actually quantified — worth noting as the actual lesson: default to neither extreme, run the numbers each time.

---

## 2026-08-27 — HubSpot integration built; full pipeline working end-to-end on local infra

**Milestone:** The complete pipeline is now mechanically working, locally, start to finish: 4 intake forms → Airtable (Create-or-Update, order-independent) → Clay enrichment (Fit Score, Find Contacts, Email Waterfall) → n8n webhook (via ngrok) → LLM personalization (Ollama/Phi-4-mini) → HubSpot (Company + Contact). First time every stage has been connected and run together rather than tested in isolation.

**Finding: unlike Airtable, HubSpot's Company resource has no native Create-or-Update (upsert) operation in n8n** — only separate Create and Update actions exist for Company, while Contact does have a combined "Create or Update a Contact" operation (HubSpot's own API supports upsert-by-email for contacts, but not an equivalent upsert-by-domain for companies). Rebuilt the same Search → If → Create/Update branching pattern used before Airtable's native upsert was discovered — same logic, just needed again because the underlying capability genuinely doesn't exist here, not because of an oversight this time.

**Finding: n8n's native "Update a Company" node has a real, documented UI bug** where the custom-properties dropdown doesn't reliably populate all custom fields (community-reported, not isolated to this project). Workaround: replaced the native Update node with a direct HTTP Request node calling HubSpot's REST API (`PATCH /crm/v3/objects/companies/{id}`) with the exact internal property names in the JSON body — bypasses the node's UI limitation entirely. Native Create node was kept as-is since it didn't exhibit the same issue. Same class of fix as the Ollama HTTP Request node — composing the API call directly rather than depending on a node's abstraction layer, now a repeated pattern in this project.

**Design note — branch reconvergence:** The Contact node sits downstream of both the Create Company and Update Company branches (only one fires per run, but both connect into the same Contact node input — no merge node needed). This worked cleanly specifically because every downstream field mapping referenced the Webhook node explicitly by name (`$('Webhook').item.json...`) rather than relying on `$json` from whichever node fired immediately before — Create and Update return differently-shaped outputs (native node vs. raw HTTP response), which would have broken a `$json`-based mapping at the reconvergence point. Worth calling out as a mapping habit that paid off, not just incidental.

**Known risk, not yet stress-tested:** community reports describe HubSpot's contact-to-company domain-based auto-association occasionally failing when the company was created moments earlier in the same run (API propagation lag), resulting in a duplicate company instead of a correct association. Flagged for verification — check the Associations tab on resulting Contact records, not just execution success, before trusting this at any real scale.

**Still deferred, from the 2026-08-25/26 sessions:** LLM output quality (Phi-4-mini's instruction-following gaps — invented a signature, ignored length constraints, used a phrase the prompt explicitly banned) has not been addressed; this pipeline run used the local model's imperfect output as-is, consistent with the "mechanics first, quality/final data second" two-pass approach already logged.

---

## 2026-08-28 — HubSpot Notes/Associations built via HTTP Request; LLM swapped to GPT-4.1 mini; full pipeline complete

**Decision:** Went with the full Notes + Associations build (two HTTP Request nodes: create note, then associate to Contact via the v4 Associations API) rather than the simpler custom-Contact-property alternative discussed earlier, despite the added complexity.

**Why the more complex path, reversing the earlier lean toward "simpler":** The custom-property route was recommended primarily for build simplicity — reusing the existing Contact upsert node with one more mapped field, no new nodes needed. Went with real Notes/Associations instead specifically because HubSpot's Activity Timeline is purpose-built for logging outreach over time (each note is a distinct, timestamped record) versus a property that gets silently overwritten on every re-run — a real distinction if this pipeline is ever re-run against the same contacts more than once (which the two-pass plan already guarantees it will be, once the BDE-data pass happens). Chose the version that better resembles how a real CRM would be used, consistent with treating this as a portfolio-grade artifact, not just the fastest path to a working demo.

**Finding: n8n's native Contact node returns HubSpot's legacy v1 API response shape** (`vid`, `canonical-vid`, `portal-id` at the top level), not the newer v3/v4 CRM shape used elsewhere in this pipeline (Company node, Notes API). The contact's ID needed for the Notes-Associations PUT request is `vid`, not `id` as initially assumed by analogy with the Company node's output — caught by inspecting the actual returned JSON rather than assuming consistency across HubSpot's own API surface. Third instance in this project of the same lesson (after the duplicate-form-field collapse and the Airtable Typecast research correction): verify the actual data shape against a live test before trusting an assumed structure, especially when different parts of the same platform (HubSpot v1 vs v3/v4) don't behave consistently with each other.

**Small fix, same session:** contact `lastname` field carried a stray leading tab character from the name-splitting expression — resolved by adding `.trim()`.

**Milestone — full pipeline complete and tested end-to-end:** 4 intake forms → Airtable (Create-or-Update) → Clay enrichment (Fit Score, Find Contacts, Email Waterfall) → n8n webhook (via ngrok) → LLM personalization → HubSpot Company (upsert via HTTP Request) → HubSpot Contact (native Create-or-Update) → HubSpot Note (created + associated via HTTP Request). LLM step confirmed swapped from local Ollama/Phi-4-mini (dev/testing) to GPT-4.1 mini (managed API) for this run — side-by-side comparison on the same Switch Mobility payload showed GPT-4.1 mini correctly followed all prompt constraints (length, no fabricated signature, no banned phrases) where Phi-4-mini failed on all three, concrete evidence supporting the earlier "local for dev, managed API for deployment" cost/quality decision.
