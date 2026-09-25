# Decisions Log

Running record of key decisions and tradeoffs made on this project, and why. Kept honest and dated — this is as much a portfolio artifact as the code itself (shows real engineering judgment, not just output).

---

## 2026-08-16 — Capstone project selection

**Decision:** Build the GTM/AI automation capstone for Atharva Metals & Engineering, a sheet-metal stamping manufacturer, instead of a generic/fictional SaaS demo.

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

**Decision:** Log progress privately (not published) for now. Revisit going public in 3–4 weeks once there's real, demoable progress — and once it's clear what needs anonymizing given this touches a real, willing partner business's operational data.

**Why:** Currently employed full-time; premature public posting about a career pivot risks unwanted attention at the current job. Also need to think through what's safe to share publicly about a real company's operations before anything goes live. The habit (private logging) is what compounds — audience can be added later without cost.

---

## 2026-08-17 — Oracle Cloud attempt and pivot to GCP

**Decision:** Abandoned Oracle Cloud "Always Free" after three separate, unrelated failures during signup/provisioning; moved to GCP's e2-micro (also free-forever) instead.

**What happened, in order:**
1. **Billing-address verification failure** — Oracle repeatedly rejected a billing address that matched the card issuer's records exactly, a known and commonly-reported issue with no reliable single fix (tried reformatting state name, disabling autofill — didn't resolve it).
2. **Client-side signup bug** — after resolving the billing prompt, the "Start My Trial" flow hung on a spinner; network logs showed a CORS error and a blocked request (`ora_code.js`) on Oracle's own signup script, unrelated to anything on my end.
3. **Known capacity risk, never even reached** — researched best-odds regions (Singapore, Frankfurt) in case provisioning itself also failed, but didn't get that far given the above.

**Why give up rather than push through:** The original case for Oracle was more RAM/OCPU headroom (2 OCPU/12GB vs GCP's ~1GB) in exchange for accepting more setup friction as a deliberate skill-building tradeoff (see 2026-08-16 VM provider entry). That tradeoff assumed the friction would be *capacity-related* — a known, bounded risk we'd already planned around. Instead the failures were pre-provisioning, on Oracle's own signup infrastructure, with no clear resolution path and no way to know if a fourth attempt would succeed. Continuing to debug someone else's broken signup flow stopped being "infra-ownership skill-building" and became pure sunk-cost risk with no learning value. GCP was the pre-agreed fallback for exactly this scenario (see 2026-08-16 provider selection entry) — used as intended rather than reactively.

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

**Fit Score:** Built as a Clay AI column using GPT-4.1 mini (lowest-cost option at 1 credit/row). Tested against known strong/weak fits (Hindware, Carrier Midea vs. Mivi, PEI-Genesis) before trusting it — confirmed real score discrimination (30-93 range) rather than a model defaulting to a safe middle score. Prompt built from a factual Atharva capability description (materials, tonnage, certifications, current customers) plus the "strategic growth partner" framing surfaced from real BDE intake answers ("when he grows, we grow") — this reframing came *after* initial scoring and is a documented follow-up, not yet re-run into the scores as of this entry.

**Find Contacts at Company:** Originally attempted via Apollo (logged separately, 2026-08-24), hit a paid-tier API wall, pivoted to Clay's own native action. Configured against the 7-persona title/seniority/department filter set developed collaboratively (Procurement, Sourcing/Supply Chain, Operations Director, Plant Head, VP/Head of Manufacturing, Quality Assurance, Design Engineering/NPD) — the Engineering-track persona was added specifically after the BDE's real answer that Procurement *and* Engineering jointly own the final decision, correcting an initial persona set that under-weighted Engineering.

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

**Requirement this places on the HubSpot sync design:** must use a stable match key (company domain, mirroring the `Company Name` match-key pattern already used for Airtable) so the eventual BDE-informed re-run *updates* existing HubSpot records via upsert rather than creating duplicates. Building this correctly on the first pass, not deferring it — a re-run that creates duplicate CRM records would undermine the entire point of treating the second pass as validation rather than a fresh start.

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

---

## 2026-08-28 — Deferred cloud deployment for the BDE-data pass; running locally at 150-row scale instead

**Decision:** Run the final BDE-data pass (150 companies through the full pipeline) on the existing local n8n + ngrok setup rather than completing the managed self-host deployment first, reversing the plan implied by the original two-pass framing.

**Why:** No near-term expectation of running this pipeline regularly or on an ongoing basis — it's not becoming a live, continuously-used tool for Atharva in the immediate future. Given that, the concrete benefits of cloud deployment (reliability during long/unattended runs, a persistent demoable artifact independent of a laptop being on, proving the upsert logic against real cloud infra) don't currently outweigh the setup time, since the pipeline's actual near-term usage pattern is occasional/demo-oriented rather than continuous.

**Real risk accepted, not ignored:** ngrok's free-tier tunnel reliability over a sustained 150-row run is a genuine concern (a mid-batch drop means a partial run and manual reconciliation of which rows completed). Mitigated procedurally rather than architecturally — disabled sleep/lock during the run, kept the ngrok terminal visible to catch a drop immediately, and split the batch into smaller chunks rather than one continuous 150-row run, so any failure has a small, easily-identified blast radius.

**Worth revisiting:** if this pipeline is ever picked up for regular/ongoing use by Atharva's BD team, or if a persistent demoable version becomes valuable for the job search / portfolio phase, the cloud deployment plan (managed self-host n8n + managed LLM API, both already decided and quantified in the 2026-08-25 entries) remains the documented next step — nothing about this decision invalidates that plan, it's a "not now" based on actual near-term need, not a reversal.

---

## 2026-09-02/03 — Trial-expiry pivot: burn credits, abandon job postings, prioritize time over cost

**Decision:** On discovering Clay's trial credits expire with the trial (not carried into the permanent Free plan) and only ~5 days remained, reversed the BYOK-for-savings strategy from 2026-08-25 — ran Fit Score and all AI columns on Clay's managed account rather than personal API keys, since unspent credits would be lost regardless. Re-prioritized remaining time around maximizing throughput (company volume, enrichment completeness) rather than credit efficiency, since credit math confirmed 6+ full passes were affordable within the trial — time, not credits, was the real constraint.

**Job postings signal abandoned, not just cost-deferred:** Tested two providers (Clay-native "Find active job openings" at 0.5/row, then Pubrio's "Find open jobs at company" at 5/row once cost stopped mattering) against the same best-case company (Panasonic). Both returned zero India-relevant results — Pubrio found 4 jobs, none in India (Canada, Warsaw, Mexico). Two independent providers failing identically on the best-case test company confirmed a structural India-market coverage gap in job-listing data sources generally, not a provider-specific or filter-specific issue. Dropped this signal type entirely rather than testing a third provider.

**News-based signal kept and built out successfully** — Google News search + a structured-output ("hasSignal"/"signal"/"signalType") summarization AI column, with explicit rules to exclude negative/risk signals, off-topic noise, and duplicate stories, and to never fabricate a signal when none exists. Tested against real Panasonic data (10 raw results, mostly noise) and correctly isolated the one genuine signal (investment commitment) while excluding a shutdown-risk story and irrelevant results.

---

## 2026-09-02/03 — Fit Score rebuilt with structured output, competitor exclusion, and manual-target exemption

**Decision:** Rebuilt the Fit Score column (deleted and restarted) using JSON structured output (`companyName`, `rationale`, `isCompetitorOrSupplier`, `industryFit`, `geographicFit`, `companySize`, `needSignals`, `total`) instead of free-text output — enables direct field mapping into Airtable/HubSpot without string parsing, and gives filtering logic (competitor exclusion, cutoff threshold) a clean boolean/integer to check rather than parsing rationale text.

**Reweighted Industry Fit per BDE real data:** white goods/appliances scores at/near max (proven 80% of Atharva's revenue); automotive scores well but moderately lower (proven capability match but only ~1% of actual revenue); furniture and off-road explicitly instructed as moderate-to-strong, not underweighted relative to automotive — corrects an earlier version that risked over-indexing on automotive given the original search results skewed that direction.

**Manual targets exempted from the ≥70 cutoff.** Discovered via real Fit Score runs (Panasonic scored 48, later corrected context showed research kept landing on wrong Panasonic sub-entities out of 6+ LinkedIn pages) that large multi-entity named targets are the ones most likely to be incorrectly filtered out by a pure score cutoff — precisely because their scale/complexity makes cold research harder, not because they're poor fits. All BDE-named and PLI-sourced manual targets advance regardless of score; only Company-Search-sourced rows are filtered at ≥70.

**60-69 band gets manual review, not auto-exclusion.** Established after Fybros (68) and Mitsubishi Electric Europe BV (65) were both found to be genuine category matches (fans/HVAC, matching real Atharva customer categories) scored low due to "no evidence found" rather than "evidence of mismatch" — the AI scores conservatively when research is inconclusive, which isn't the same as a bad fit. Kampmann Group (63) was correctly excluded on manual review — genuine category miss (building climate-systems integration vs. Atharva's proven appliance-manufacturing HVAC category), not a confidence problem.

---

## 2026-09-02/03 — Contact handling: dedup to one per company; no-email contacts get a real match key

**Decision:** After Find Contacts frequently returned many near-duplicate contacts per company (Havells alone returned ~15), applied a manual "keep best match per company" pass rather than pushing all returned contacts through — prioritizing exact persona/title matches (e.g., "Sourcing Procurement Manager" over multiple generic "Production Manager" hits).

**No-email contacts get a genuine upsert, not a synthetic email or one-way create.** HubSpot's native Contact node requires email as its match key; initially considered a synthetic/placeholder email but rejected it as fake data sitting in a real field. Confirmed `hs_linkedin_url` is a real, working, HubSpot-defined default Contact property (verified against live account data after conflicting community reports about its visibility) — used as the match key for a manual Search → If → Update/Create pattern (same shape as the Company upsert), giving no-email contacts a real upsert path instead of a fake email or create-only branch.

**Personalization and Note creation moved to run unconditionally, not gated by email status.** Original design skipped LLM personalization entirely for no-email contacts on the reasoning that "no email means no automated send anyway." Reversed once it was clear nothing in the pipeline sends email automatically regardless — the Note is always a manual-send draft. No-email contacts are exactly the ones where a strong draft matters most, since a human already has more manual work to do (finding contact info) — worth doing the personalization for them too, not less.

---

## 2026-09-02/03 — Personalization prompt: added company_description for specificity; dropped opportunity-signal fields after a root-caused Clay bug

**Finding:** Testing the personalization output against Switch Mobility (no opportunity signal available) showed the LLM correctly followed all format rules but produced only generic, hedged language ("your requirements likely demand quality") — traced to the input itself: the Fit Score rationale is once-paraphrased AI summary, not concrete facts. Fixed by adding the original scraped `company_description` as a second input field, with an explicit instruction to pull one concrete, named detail (a product line, certification, or facility) rather than paraphrase further.

**`has_signal`/`signal` fields removed from the payload after causing a silent Clay-side failure.** Adding these two fields to the Clay → n8n HTTP body caused every enrichment run to hang indefinitely with zero trace in n8n's logs — isolated via a systematic one-field-at-a-time re-add process (after confirming via direct curl that n8n/ngrok were completely healthy) to these two fields specifically. Root cause not fully diagnosed (likely a Clay-side JSON construction issue with the boolean/conditional field), but rather than continuing to debug under time pressure, removed both fields and dropped the opportunity-signal → personalization linkage for this pass. News/Summarization data still exists in Clay and HubSpot Company records but isn't currently feeding into the outreach draft text.

---

## 2026-09-02/03 — Recurring n8n bug pattern: unescaped free-text fields breaking raw JSON HTTP bodies

**Finding, hit three separate times across three different nodes (LLM Personalization, Create Note, Update Company):** any HTTP Request node using a raw JSON body string that directly interpolates a long free-text field (`fit_rationale`, `company_description`) breaks with a "bad control character" JSON parse error whenever that field contains a real line break or embedded quote — which scraped company descriptions and AI-generated rationales both do routinely. Root cause: expression interpolation into a hand-written JSON string doesn't automatically escape special characters the way HubSpot/OpenAI's own SDKs would.

**Standing fix, applied as a rule going forward:** any field genuinely likely to contain multi-sentence or scraped text must be wrapped `{{ JSON.stringify(fieldRef).slice(1, -1) }}` before insertion into a raw JSON body — short/simple fields (names, titles, scores, domains, single URLs) don't need this treatment. Documented here so this isn't re-debugged from scratch again if it resurfaces in a node not yet touched.

**Separate, related bug: duplicate default node names caused wrong `$()` reference resolution.** Multiple HTTP Request nodes left with n8n's default "HTTP Request" name caused a downstream expression (`$('HTTP Request')`) to silently resolve to the wrong node depending on which branch executed, producing "node hasn't been executed" errors that looked like a logic bug but were actually a naming collision. Fixed by renaming every node to a unique, specific name — adopted as a standing practice for all future nodes in this workflow.

---

## 2026-09-03 — v1 pipeline complete: full BDE-data run successful across all 19 contacts

**Milestone:** First fully successful end-to-end run of the complete pipeline against real, BDE-informed data — all 19 contacts (spanning both the has-email and no-email branches, both native and custom HubSpot upsert paths, both Company and Contact records, with Notes created and correctly associated) processed without error. This closes out v1 of the pipeline as originally scoped: 4 intake forms → Airtable → Clay enrichment (Fit Score, Find Contacts, Email Waterfall, News/Summarization) → n8n (LLM personalization, dual Contact-branch handling) → HubSpot (Company, Contact, Note).

**What "v1 complete" means in practice:** every major bug class hit during this final sprint (JSON escaping, node-naming collisions, the email-required Contact constraint, the enum-restricted HubSpot `industry` field, the Clay HTTP timeout tied to specific payload fields) has been found and fixed at least once, and the fixes held across a real multi-branch batch, not just isolated single-row tests.

**Next phase:** repeat the Clay search → curate → enrich → push cycle to process additional batches within the remaining trial window, maximizing total prospect volume before credits/trial access expire, per the strategy locked on 2026-09-02/03.

**Documentation note:** this entry also marks a fix to the decisions log itself — every previous edit in this file had been inserting new content immediately before the "Time estimate: build vs. buy" entry (2026-08-16), which pinned that entry to the end of the file regardless of its actual date. Corrected by moving it to its proper chronological position (immediately after the "Intake questionnaire delivery" entry it references). Worth remembering for any future edits: anchor insertions to the actual most-recent entry at the time of writing, not a fixed historical anchor point.

---



## 2026-09-03 — Scaling sprint: 82 contacts pushed to HubSpot; geography rotation findings

**Milestone:** 82 total contacts processed through the full pipeline and pushed to HubSpot, up from the 19-contact first successful run — achieved by cycling the proven Company Search → Fit Score → Contacts → Email Waterfall → HubSpot loop across multiple company pools within the final trial window, rather than a single one-shot batch.

**Geography rotation results, tested systematically across the sprint:**
- **Winning combination: India, UK, UAE, Germany, Italy** — Germany initially scored near-zero when tested broadly (appliances/HVAC only), but recovered strongly (48/50 above threshold) once narrowed to include the furniture category specifically — root cause was a stale Fit Score prompt that only rewarded India/UK/UAE on Geographic Fit and hadn't been updated when Germany was added to Company Search. Fixed by updating the rubric; Italy was added on the same proven furniture-narrowed filter set and also converted well ("decent" hit rate), without needing a separate diagnostic cycle.
- **US and Mexico excluded throughout** — steep current tariffs on steel/aluminum-heavy exports (US: 50% Section 232; Mexico: up to 50% on flat steel specifically), researched and decided early in the BDE-data phase.
- **EU-broad (Germany + Italy together, appliances/HVAC only, no furniture) underperformed badly** — abandoned rather than debugged further, given the furniture-narrowed version was already proven to work; not worth the time to diagnose why the broad version failed once a working alternative existed.
- **Vietnam/Thailand/ASEAN researched but deliberately not pursued** — genuinely large metal-furniture export market ($1.8B from Vietnam alone), but flagged as high-risk: regional manufacturing base skews toward OEM/ODM production and forging/foundry capability, resembling the same supply-side risk profile that caused the Industrial Machinery dead end below. Not worth testing this late in the sprint without time to diagnose a possible repeat failure.

**Industry rotation results:**
- **Furniture and Home Furnishings Manufacturing** — the standout performer of the entire session (30/50 in its first dedicated test), likely because the category maps more cleanly to genuine buyers (steel-framed chairs/desks/cabinets) than some other tags.
- **Industrial Machinery Manufacturing (retried with a mature exclusion list)** — confirmed dead end, 0/50 above threshold, with every scored row correctly flagged `isCompetitorOrSupplier: true`. Root cause: this Clay industry tag captures machinery/equipment *makers* (Atharva's supply side — presses, tooling, forging equipment) rather than machinery *buyers*. The BDE's stated interest in "Industrial Equipment" as a growth category should be pursued via a different search approach (e.g., explicit buyer-side keyword targeting) if revisited, not this industry tag.

**Process-level finding:** narrowing Estimated Employee Count (150-1,000 vs. the proven 150-5,000) correlated with a severe hit-rate drop (11/227, ~5%) in an isolated test — attributed to the Fit Score prompt's "score conservatively when research is inconclusive" rule interacting badly with smaller, less-documented companies, not a genuine fit problem. Reverted and not retested narrow again.

**Time allocation, final sprint:** once Clay's trial credit-expiry timeline became known (5 days, later 16 hours), strategy shifted explicitly from credit-conservation to time-conservation — actual usage data confirmed credits were never the binding constraint (a full ~50-row cycle cost roughly 100-200 credits against a 2,000-credit balance), so all remaining effort was directed at maximizing manual-review speed (mechanical Fit Score cutoffs, no line-by-line company review, Find Contacts capped at 1 result) rather than credit efficiency.

## 2026-09-03 — Sprint closes at 126 contacts: final rotation results, v1 pipeline complete

**Final milestone:** 126 total contacts pushed to HubSpot by the end of the Clay trial window — up from 19 (first successful end-to-end run) to 82 (mid-sprint checkpoint) to 126 (final). Closes out the BDE-data scaling sprint and, with it, v1 of the GTM automation pipeline as a complete, portfolio-ready artifact: real intake data, real enrichment, real (if AI-scored) prospects, real CRM records.

**Automotive, revisited late and confirmed viable.** Originally deprioritized early in the BDE-data phase on the strength of the 1% revenue signal alone, without an actual conversion test. Retested this session with a mature exclusion list and converted well — confirms the earlier deprioritization was a reasonable caution given the data available at the time, but not a permanently correct call. Worth remembering as a general lesson: a category deprioritized on indirect signal (revenue share) may still be worth a direct test once the tooling (exclusion keywords, Fit Score prompt) has matured past its earlier state.

**South Korea tested twice, failed both times — a genuine, confirmed negative result, not noise.** First against the general appliances/HVAC/furniture set (near-zero), then paired specifically with automotive on the theory that Korea's strength is auto manufacturing (2 companies only). Two failures across two different category pairings is stronger evidence than one, and was treated as sufficient to drop the market entirely rather than testing a third combination.

**Considered but explicitly declined: a combined automotive + appliances/HVAC/furniture search**, on the reasoning that both underlying searches had already been run to full backfill exhaustion independently — a combined search would only surface genuine new leads from the narrow cross-category overlap (e.g., a company like Trans ACNR, which is both automotive and HVAC-relevant), not from re-covering already-searched ground. Judged not worth the setup time this late in the sprint; flagged as a legitimate but low-yield tactic if ever revisited.

**Aerospace & Defense was considered but deliberately excluded from the entire final sprint**, despite being one of the BDE's named growth-interest industries — Atharva does not hold AS9100/NADCAP certification, so aerospace leads represent a genuine capability gap, not just an unproven category. This is a different kind of risk than the geography/industry mismatches encountered elsewhere (wrong companies surfacing vs. right companies Atharva can't actually serve) and was judged not worth pursuing without a real certification plan in place.

**What v1 represents, for the portfolio record:** a working pipeline spanning 4 intake forms, Airtable, Clay (Company Search, structured-output Fit Scoring with a competitor-exclusion safeguard, contact discovery, email waterfall enrichment, news-based opportunity signals), n8n (LLM-personalized outreach, dual-path HubSpot upsert logic for both email and no-email contacts), and HubSpot (Company/Contact/Note records) — built, debugged, and scaled entirely within real constraints: a hard trial deadline, genuine data-quality problems (entity disambiguation, location errors, industry miscategorization), and a series of honestly-diagnosed dead ends (job postings, Industrial Machinery, South Korea, broad EU) alongside the wins.

## 2026-09-03 — v1 declared complete

**Decision:** Marking this project as v1-complete. Every planned pipeline stage is built, tested, and has processed real data end-to-end: 4 intake forms → Airtable → Clay enrichment (search, scoring, contacts, email, news signals) → n8n (personalization, dual-path CRM upsert) → HubSpot. 126 real prospect contacts, across 5 countries and 4 industries, are live in HubSpot as the tangible output.

**Why this is a legitimate v1, not a demo:** the pipeline was tested against two genuinely different conditions — a mechanical, dummy-data build phase to prove the architecture, and a full production run against real BDE-supplied business data at meaningful scale (126 contacts, not a handful of test rows). Every component has been broken and fixed at least once under real conditions (JSON escaping across three separate nodes, a HubSpot API version mismatch, a Clay-side timeout traced to two specific payload fields, an entity-disambiguation problem affecting multi-division companies, an industry category that looked plausible but was structurally wrong for the business). None of these were theoretical risks — all were hit, diagnosed, and resolved with evidence, not guesswork, consistent with the verification discipline established from Day 1.

**What "v1" deliberately does not include, and why that's fine:** the opportunity-signal → personalization linkage (built, tested independently, but disconnected before the final production run after being identified as the cause of a Clay-side timeout, with root cause not fully diagnosed under time pressure); RFQ/tender monitoring (researched and found structurally infeasible — private OEM sourcing isn't publicly listed); a feedback loop from real outreach outcomes back into scoring (never started). These are honest, logged scope boundaries — a v1 with clear, documented edges is a stronger artifact than an over-scoped project with hidden gaps.

**Documentation state at v1 close:** `decisions.md` now contains a complete, chronological record from initial infra decisions (2026-08-16) through the final scaling sprint (2026-09-03) — every major pivot, bug, and dead end included, not just the successful path. README updated to reflect actual final architecture and results rather than the in-progress plan it described at project start.

## 2026-09-05 — Phase 2 begins: manual outreach craft, deliberately separate from the automated pipeline

**Decision:** With v1 (the technical pipeline) complete and 126 contacts sitting in HubSpot, opened a distinct second phase focused on the actual outreach — sales craft, not automation — before any messages are sent. Explicitly framed as demonstrating a different, complementary skill set: v1 proved GTM engineering (build a system that finds and scores prospects); this phase proves GTM/sales judgment (know what actually makes a stranger respond to a cold message), both relevant to the dual audience of GTM/Applied AI employers and MBA admissions.

**Trigger:** A manual review of drafted outreach Notes surfaced two real quality problems the automated pipeline couldn't have caught on its own: (1) two confirmed factual hallucinations (a fabricated "multimedia hardware supply chain" reference for Renault-Nissan-Mitsubishi, a fabricated "energy plant" reference for IVECO — both traced to thin `company_description` inputs), and (2) a structural gap — Atharva's own plant locations were never included in the personalization system prompt, so even a high-scoring geographic match (LG's Ranjangaon plant sitting at the same location as Atharva's flagship plant) went completely unmentioned in 126 auto-generated messages. Both findings reinforced that mechanically-scaled AI personalization has a real quality ceiling that manual craft can exceed for the highest-value accounts.

**Approach: tiered effort, not uniform automation.** Rather than fixing the prompt and re-running all 126, the plan splits effort: a hand-curated pilot batch of ~20 companies gets manually researched, hook-tagged, and hand-crafted messaging; the remaining ~100+ stay AI-drafted with a lighter accuracy pass. This mirrors real account-based marketing practice (not every prospect deserves equal investment) and turns the pilot into a genuine, measurable test — comparing which personalization "hook types" actually drive replies, not just confirming that hand-written beats generic.

**New data structure: `Personalization Hook Type` + `Personalization Hook Detail` on Company records**, added specifically to support later analysis (which hook types convert) and to make it easy to re-feed a hand-identified hook back into the automated pipeline via curl if useful. Ten hook categories defined from patterns found across the real company set (Plant Proximity, Dedicated Capacity Precedent, Trade Agreement Timing, Named Customer/Category Match, PLI Scheme Beneficiary, Certification Match, Known History/Re-engagement, Growth-Stage Signal, Verified News Signal, Other/Generic) — deliberately left open-ended via the "Other" category rather than treated as an exhaustive fixed list, since real research keeps surfacing genuinely new angles (e.g., LG's live, in-progress third-plant construction, which is simultaneously a Growth-Stage Signal and reinforces the Plant Proximity hook).

**Guardrail established: no hook goes out without verification.** The "Known History / Re-engagement" category specifically (the IFB/Savera Pressing story) was flagged as unsafe to use until the actual BD lead confirms which contact, if any, has direct knowledge of that history — using unverified institutional memory in outreach risks confusing or exposing internal information to the wrong person. This same discipline (verify before using a "clever" fact) applies to every hook type, not just this one.

**Also blocked on, separately:** sending itself is on hold pending `bd@atharvametals.com` credentials being available to whoever will actually send — this outreach-craft phase is deliberately being used as productive time during that wait, not blocked by it.

## 2026-09-05 — Removed build-log.md

**Decision:** Deleted `docs/build-log.md`. Its stated purpose (raw daily notes seeding future "build in public" posts) was never used past the 2026-08-16 kickoff entry — public posting was deferred that same day and never resumed, and `decisions.md` ended up serving as the actual working record at a more useful level of detail. Keeping a visibly abandoned file in the repo implied ongoing maintenance that wasn't happening; removing it is more honest than leaving it stale. README updated to remove the now-dead reference.

## 2026-09-09 — Phase 2 closes: manual hook-tagging complete, 6 more Fit Score errors caught, creative outreach concepts scoped

**Milestone:** Completed a full manual research and personalization-hook-tagging pass across the pilot batch. 20 companies received real, individually-researched hooks (LG, Voltas, IFB, Western Refrigeration, Marc Enterprises, Whirlpool, Daikin, Surya Roshni, Carrier Midea, EPACK Durable, Panasonic India, Sujata, Dimplex UK, Havells, Foster Refrigerator, Mitsubishi Electric India, Toyota Motor Manufacturing France, Škoda Auto Volkswagen India, Renault Nissan RNAIPL, Tata Motors Commercial Vehicles) — hitting the original ~20-company pilot target set at the start of Phase 2.

**Six more companies caught and removed as genuine Fit Score errors, on top of the earlier ELTEK/Stelmec catches:** Rane Madras, HL Mando Anand, and Montra Electric were all confirmed Tier-1 automotive component suppliers (steering, suspension, brake systems) that should have triggered the `isCompetitorOrSupplier` exclusion — the same category-mismatch pattern first identified with Delta Electronics and Industrial Machinery, now confirmed recurring specifically within the automotive search rotation. Montra Electric additionally revealed a more specific risk worth naming as its own pattern: its parent group (Tube Investments of India) owns a sister division, TI Metal Forming, that already does deep-drawn stamping and chassis fabrication in-house — an existing captive-supplier relationship, not just a future "backward integration" risk. I.EVO was dropped on a different basis: an unresolved, unreconciled data discrepancy (company-claimed 5,000+ employees vs. third-party data showing 124 with a 42% YoY decline) made it impossible to write confident, accurate outreach regardless of category fit.

**Total Fit Score corrections from this phase: ELTEK Group and Stelmec Limited** were confirmed via direct research (not just suspicion) to be supplier-side businesses that scored well above the 70 cutoff and have been deleted from HubSpot — a real, evidence-backed correction to the automated scoring system, distinct from a judgment call. Combined with the four automotive-round drops above, six companies total were removed post-hoc during Phase 2 that the Fit Score prompt should have excluded automatically.

**Two hallucinations from the original 126-contact batch were traced and corrected with real research rather than just flagged and discarded:** the Renault-Nissan-Mitsubishi note's fabricated "multimedia hardware supply chain" reference was replaced with the real, current story (Renault's 2025-26 buyout of Nissan's stake, plant underutilization, and a stated €2B India export target by 2030). The IVECO "energy plant" fabrication was not re-researched in this pass and remains an open item if that company is pursued further.

**One critical sensitivity finding, worth calling out as a standing rule:** Dimplex UK's contact (Anthea Mallon) is based in Magheralin, Northern Ireland — the exact region where parent company Glen Dimplex has been closing sites and cutting ~300 jobs. The correct, safe growth signal (a new Buckley, Wales facility) was substituted instead. Generalized as a standing check: **always verify whether negative company news geographically overlaps with where the actual contact is based**, not just whether the news itself is negative in the abstract — a company-level negative/positive split can still be locally sensitive to one specific person.

**New personalization hook categories validated in practice, beyond the original 10:** Dedicated Capacity Precedent (referencing Atharva's own Vasai/Bavla plants built for Blue Star/Versuni) proved to be one of the strongest-performing categories once applied retroactively across LG, Voltas, IFB, Havells, and others — a genuine miss in the original hook-type list that required a dedicated retroactive pass to fix. A systematic "Other" category check, run twice across the full company set, surfaced two more real, non-obvious signals after the fact (LG's pending IPO, Western Refrigeration's Japanese parent ownership via Hoshizaki) — validating that a deliberate "does this need its own category" check catches things pattern-matching to a fixed list misses.

**Creative outreach concepts scoped, not yet built:** to move beyond templated email personalization, discussed (1) using confirmed Plant Proximity hooks as a concrete plant-visit invitation rather than a passing mention, (2) LinkedIn connection requests as a warm touch before the email lands, (3) one-page account-specific micro-briefs for the top 5-6 companies, and (4) trigger-timed messaging framed as a timely congratulations for companies with genuinely recent news (Whirlpool's July 2026 inauguration, Havells' new refrigerator plant). None built yet — logged as the next concrete step once sending credentials are available.

**Still blocked, unchanged:** sending requires `bd@atharvametals.com` access, not yet available. This entire phase was productive use of that waiting period, not blocked by it.

## 2026-09-15 — Phase 3 strategy: tiered, multi-asset outreach system (not templated email personalization)

**Context:** `bd@atharvametals.com` access arrived right as the pilot batch's hook-tagging pass closed (20 companies researched). Rather than immediately sending 20 AI-personalized emails, deliberately paused to design a proper multi-channel outreach system — the explicit goal being to demonstrate GTM engineering (building a system that produces something a manual SDR couldn't) rather than just cold emailing with better facts.

**Decision: tiered investment, not uniform treatment across all 20.**
- **Tier 1** (5-6 strongest accounts: Whirlpool, Havells, Daikin, SAVWIPL, Mitsubishi Electric India) get a dedicated capability asset, a LinkedIn touch, and a full multi-step cadence.
- **Tier 2** (the remaining ~14-15) get a single strong, hook-specific email with no dedicated asset — the research investment shows up in message quality, not a separate artifact.
- **Why:** building a bespoke landing page, PDF, and full cadence for all 20 would consume disproportionate remaining time for uncertain marginal benefit over a well-written email on weaker accounts. Concentrate the heaviest production where it matters most.

**Decision, reversed mid-build: PDF over a live landing page as the primary Tier 1 asset.** Originally built and published a live capability-dossier webpage (Artifact-hosted) for Whirlpool as the flagship concept. On reflection before scaling it to the rest, identified a real risk not considered at build time: a link to an unfamiliar `claude.ai` domain in a cold email to a large corporate procurement team risks corporate email security flagging, or simply not being clicked by a security-conscious recipient. A PDF attachment is the more conventional, more trusted format for a cold industrial capability submission — it doesn't ask the recipient to trust an unfamiliar link. **The landing page is kept as a secondary, optional link mentioned only after some trust is established (e.g., in a follow-up), not the first-touch asset.** Worth noting as a real example of catching a strategic flaw in a concept only after starting to build it — a good argument for the "strategize and document before generating artifacts" discipline being applied here.

**Landing page brand-matching, done regardless of the format reversal:** before building further, fetched and visually inspected the real atharvametals.com site (screenshots) to extract the actual brand identity — a vivid blue palette (~#2563EB), navy headlines, rounded cards with soft shadows, pill-shaped eyebrow badges, bold geometric sans-serif headings (Plus Jakarta Sans-style) — and rebuilt the Whirlpool page to match it exactly, replacing an initial self-designed "industrial blueprint" aesthetic that, while intentional and well-reasoned on its own, did not actually match Atharva's existing brand. Standing lesson: when told to match an existing brand, fetch and inspect the real thing rather than design a plausible-sounding aesthetic from the subject matter alone — the two are not the same test.

**Multi-touch cadence, revised down from an original 4-touch LinkedIn+email plan to a realistic 2-channel plan:**
- Day 0: LinkedIn connection request (Tier 1 only) + email with the capability asset (Tier 1) or hook-specific email only (Tier 2)
- Day 7-10: a short, differently-angled follow-up if no reply
- No third touch without a genuine new reason — avoids reading as pestering.

**LinkedIn channel resolved:** Atharva has no company LinkedIn page (a gap first identified early in the project's public-digital-presence research). Rather than building the cadence around a channel that didn't exist, a personal "Business Development Executive @ Atharva Metals" LinkedIn profile was created to serve as the sending identity for the Tier 1 LinkedIn touch.

**Deliverability risk identified and built into the send plan:** `bd@atharvametals.com` is a fresh or lightly-used mailbox; sending 20 cold emails at once from an unfamiliar domain risks spam-filtering before any prospect sees the message. Plan: stagger initial sends thin (2-3/day for the first several days) to build minimal sending reputation before reaching fuller pace, rather than sending the full batch at once.

**Response-handling ownership flagged as a real, not cosmetic, risk:** Atharva's own intake data named "slow quote turnaround" as its biggest internal bottleneck — meaning the outreach campaign's own success could expose that exact weakness if replies aren't handled promptly. Explicit ownership of monitoring `bd@atharvametals.com` needs to be assigned before the first send, not left implicit.

**Tracking, minimal and deliberate:** date sent, tier, channel(s) used, reply Y/N, sentiment, meeting booked — logged per contact, feeding the still-open v2 feedback-loop idea (which hook types and formats actually convert) as a natural byproduct rather than a separate build.

**Process note:** this entry itself is an example of the "document the plan before generating artifacts" discipline being explicitly re-applied after briefly drifting into building the Whirlpool page ahead of the full strategy being settled — corrected mid-session rather than after the fact.

## 2026-09-16 — First real outreach sent: 5 Tier 1 LinkedIn connection requests

**Milestone:** Sent LinkedIn connection requests to all 5 Tier 1 contacts — Moganradjou M (Whirlpool), Alok Gupta (Havells), Satish Kaul (Daikin), Rakesh Dhankhar (Mitsubishi Electric India), and Anand Bakhare (SAVWIPL). First genuine outreach action of the entire project — everything before this point was pipeline-building; this is the pipeline's actual purpose being exercised for the first time.

**Message drafting went through real, useful iteration before sending, worth recording:**
- First drafts over-credentialed the connection note — opening with role/certification before any human framing, and repeating an identical closing phrase ("I'd welcome the opportunity to connect") across all five, which read as templated despite genuinely different facts underneath.
- Second drafts overcorrected toward casual phrasing ("small world," "interesting move") that undercut professionalism.
- The working template came from the user directly: "I'm reaching out on behalf of [Company], based in [location]. Our facility is [proximity], and we'd welcome the opportunity to work with your team" — kept as a consistent, genuine human structure (not a generic AI default) with the specific hook varied naturally per company.
- **Standing rule established for this channel:** a LinkedIn connection note's only job is getting accepted — it should carry one clear, specific fact, not the full case. Investment figures, named-executive quotes, and multi-point rationale are deliberately held back for the email/PDF stage, where there's room to make them land. Applied consistently across all five final drafts (e.g., Daikin's note references the localisation push directionally without the ₹1,400cr/₹1,000cr/₹500cr figures; those are reserved for the follow-up).

**One contact upgraded mid-process:** researched and found Satish Kaul (GM, Central Procurement and General Purchase) as a stronger primary contact for Daikin than the two originally in HubSpot (a Plant Head and a Supply Chain Manager) — added via the same manual curl-to-webhook path used for Whirlpool and IFB earlier, rather than replacing the existing contacts outright.

**Next step, per the Phase 3 cadence plan already logged:** use the waiting period before it's appropriate to follow up with email to build the Tier 1 email drafts and the Whirlpool PDF capability brief (still the one asset not yet built), rather than waiting idle. Company LinkedIn page remains a background, non-blocking task per the earlier decision to proceed with outreach rather than let that hurdle delay sending.

## 2026-09-25 — Technical capability document rebuilt from scratch after a real design misstep, plus a certificate correction

**Decision, reversing an earlier build:** The first capability PDF (built in the Phase 3 "creative outreach" push) was rejected on real, substantive grounds — it read as a marketing one-pager (a CTA button, an "open door" closing line duplicated verbatim from the accompanying email) rather than the technical reference document a genuine engineering/procurement reviewer would expect. Feedback was direct: repeating marketing copy across the email and the attachment "will make us lose all credibility." Rebuilt from a plain-text content outline first (per explicit instruction: no file generation until content is agreed), then built as a proper multi-page, data-forward technical document — real tables, no persuasive language, no CTA.

**New source material: a real company deck (`AME_Profile_Sep-25.pptx`) from the business, studied in full before building anything.** This surfaced substantially better technical detail than anything gathered via the earlier questionnaire attempt: a full 17-machine press specification table (make, tonnage, bed size, stroke, cushion, frame type), a year-by-year capability timeline (2019-2024), real reference parts with actual dimensions (a 120mm-deep, 1.6mm-thick deep-drawn dome assembly; a TORO steering-column tube-and-bracket assembly with real part numbers), and two named customer awards (Haier Best Business Support Award, Toro Best Development Award).

**Real discrepancies surfaced and resolved by direct confirmation, not assumption:**
- This deck covers the **Pune/Ranjangaon plant only** — Vasai and Bavla have separate equipment lists not included here. The technical document states this scope explicitly rather than implying company-wide figures.
- **Financial figures updated**: this deck's ₹18cr (FY19-20) → ₹106cr (FY25-26 projected) supersedes the earlier $2.2M-$17.1M figures used throughout the project to date, per confirmation this data is more current.
- **Workforce figures**: this deck's org-chart headcount (35 staff / 20 operators / 90 contract) was *not* used, since it's likely scoped differently than the BDE intake's headline numbers (70 on payroll, 251-500 including contract) — the BDE figures were kept as the standing reference.
- **A critical, real certificate discrepancy**: the actual IATF 16949 certificate scan embedded in the deck shows certificate number **0458146**, expiring 2025-09-19 — directly conflicting with certificate number **0582617**, which had been used in every email and PDF built earlier in Phase 3 (sourced from a website screenshot at project start). Confirmed 0582617 is the current, correct number (the deck's certificate has since been renewed) — 0458146 was a superseded certificate, correctly not used anywhere in the final document. The outdated certificate *image* itself was also excluded from the final document for the same reason; certificate details are stated as text only pending a current scan.
- **Corrected the IATF certification timeline**: the deck's own capability timeline shows ISO 9001:2015 achieved at founding (2019) and IATF 16949:2016 achieved in 2021 — not "since inception" as had been stated in every prior outreach asset. This is a factual correction that needs to propagate to the already-built Tier 1 emails and any other material still carrying the old claim.
- **A real certification scope caveat, now stated accurately**: the certificate explicitly excludes product design ("without Product Design as per Chapter 8.3") — the document now states this precisely, crediting Atharva's design capability (SolidWorks/AutoCAD, a named external partner Rheomold Engineering Solutions LLP) as a separate, non-certified function rather than implying it falls under the IATF scope.
- **"First customer since 2019" (Haier) framing dropped entirely** — judged to be founder-story material irrelevant to a technical qualification document; Haier's real relevance (current OEM program, real part types, a named award) is represented directly in the relevant sections instead.

**Format, confirmed:** a single, non-personalized technical PDF, sent as an email attachment (not embedded, not a hosted link) — the same trust/deliverability logic as the earlier marketing-PDF decision, now applied to a document too long and too reference-oriented to belong in an email body at all. This document replaces the earlier one-page marketing PDF concept entirely; one attachment per Tier 1 email going forward.

**Images: selective inclusion, judged against a real bar, not by default.** Confirmed useful: a genuine certificate scan (deferred, pending a current one) and reference part photos specifically paired with real spec callouts (the deep-drawn hob, a bottom panel assembly, the TORO tube-and-bracket assembly — all extracted directly from the source deck's embedded media). Deliberately excluded: generic machine photos and a plant photo, on the reasoning that neither adds information a technical reader would actually weigh — both would have repeated the same "decoration over evidence" mistake just corrected in the first draft.

**Build note:** the exact brand typeface (Plus Jakarta Sans) isn't installable in this environment without network access; substituted with **Poppins**, a genuinely close visual match already available as a system font, rather than defaulting to a generic sans that would have broken brand consistency with the webpage and email already built.

## 2026-09-25 — Send timing: deferred to Tuesday/Wednesday, not sent this week

**Decision:** Delayed the first real email send (beyond the LinkedIn touches already sent) past the current Friday, which coincides with the Ganesh Visarjan holiday affecting a meaningful share of the target list — Whirlpool, LG, Voltas, SAVWIPL, Mitsubishi Electric India, Carrier Midea, Western Refrigeration, and Trans ACNR are all Maharashtra-based or -adjacent. Combined with the independent, holiday-unrelated convention of avoiding Friday/Monday sends generally (Friday emails get buried under Monday's backlog), the safer window is Tuesday or Wednesday of the following week. The 3-day gap is being used productively: extending hook-tagging research to remaining companies, a full QA pass on already-built assets, confirming send infrastructure readiness, and this documentation pass — not idle waiting.

## 2026-09-25 (cont.) — 12-company Tier 1 batch reaches parity: LinkedIn sent + email drafted for all

**Milestone:** All 12 Tier 1 companies now share the same baseline — a LinkedIn connection request sent and a fully drafted, hand-crafted outreach email ready — with the technical capability document as a shared attachment across all of them. Companies: Whirlpool, Havells, Daikin, Mitsubishi Electric India, SAVWIPL, LG, Voltas, IFB, Western Refrigeration, Trans ACNR, Carrier Midea, Foster Refrigerator.

**Two real contact corrections made during this pass, both caught before sending, not after:**
- **IFB**: original contact Abhijit Chikate had left the company since being sourced. Researched three replacement candidates found on IFB's LinkedIn company page; compared them directly (Supply Chain Manager vs. Procurement Senior Engineer vs. Quality Manager) and selected **Sharmistha Dey, Supply Chain Manager**, whose own profile explicitly names "Sheet metal, Pressed" as an owned sourcing category — a more precise functional match than the original contact had. Her work email could not be found (masked/paywalled on every source checked); routed through the no-email/`hs_linkedin_url` Contact branch rather than guessing at an email pattern. Abhijit's stale contact record was deleted rather than left in place, since he's no longer with the company (unlike the Foster Gamko case below, where the record is a genuinely different, still-relevant entity worth keeping dormant).
- **Foster Refrigerator vs. Foster Gamko**: discovered these are two separate HubSpot Company records — Foster Refrigerator (the actual target, with the correct contact Steven Ennis on the `foster-uk.com` domain) and Foster Gamko (a related/sister brand with two other contacts, likely reflecting a real corporate structure given Steven Ennis's own title spans "Global Refrigeration"). Foster Gamko's contacts were deliberately left in place as a dormant, potentially useful record for future outreach, not deleted — a genuine second company, not a duplicate.

**Send schedule finalized**: Tue AM (Whirlpool, LG, SAVWIPL) \u2192 Tue late AM (Voltas, IFB, Western Refrigeration) \u2192 Tue PM (Daikin, Mitsubishi Electric India, Trans ACNR, Carrier Midea) \u2192 Wed AM, UK hours (Foster Refrigerator) \u2192 Wed AM (Havells, corrected back into the schedule after being dropped by mistake in an earlier draft of the plan).

**Deliverability posture relaxed**: `bd@atharvametals.com` was confirmed to be an established, already-in-use mailbox, not a fresh one as originally assumed \u2014 the earlier cautious 2\u20133/day pacing plan (designed for a brand-new domain) was relaxed accordingly; a moderate, batched pace across Tuesday\u2013Wednesday was adopted instead of the original multi-day drip schedule.

**HubSpot tracking decision**: rather than a separate tracking spreadsheet, outreach status is tracked natively in HubSpot via a new `Outreach Status` custom property, kept in sync with the CRM rather than a disconnected document. Defined values: **LinkedIn Connection Request \u2192 Email Sent \u2192 Replied \u2192 Meeting Booked**, plus **No Response** and **Not Interested** as terminal states. All 12 Tier 1 companies set to "LinkedIn Connection Request" as their current status.

**Read receipts investigated and deliberately not relied upon**: Gmail read receipts require Google Workspace admin enablement and explicit recipient approval per email \u2014 real, but unreliable for cold outreach to strangers who are likely to decline. A genuine reply remains the primary success signal; read receipts were not built into the tracking plan.

**Remaining scope, not yet converted to ready-to-send emails**: hook research already exists for Marc Enterprises, Surya Roshni, EPACK Durable, Panasonic India, Sujata, Dimplex UK, Toyota Motor Manufacturing France, Renault Nissan (RNAIPL), and Tata Motors Commercial Vehicles \u2014 a real, low-effort extension path once the current 12-company batch is confirmed sending cleanly.
