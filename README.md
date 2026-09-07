# GTM AI Automation — Capstone Project

**Status:** ✅ v1 complete — 2026-08-16 to 2026-09-03

## What this is

An AI-powered GTM automation pipeline built for a real business: Atharva Metals & Engineering, a sheet-metal stamping manufacturer producing stamped components for appliance, HVAC, automotive, and furniture manufacturers. I identified traditional manufacturing as an industry largely untouched by modern GTM/AI tooling and deliberately chose to build in this underserved space rather than another SaaS-demo use case — Atharva became the real, willing partner to prove the approach against. The company previously ran business development almost entirely through referrals and manual outreach, with no digital sourcing/prospecting layer.

This pipeline:
1. Collects structured operational, process, and strategic data from the business via a 4-chapter intake questionnaire
2. Searches for and identifies target OEM accounts across multiple industries and geographies via Clay
3. AI-scores each prospect against the company's real capability profile and ICP, with a structured-output rubric and an automatic competitor/supplier exclusion safeguard
4. Finds and verifies contacts at qualifying companies, filtered to relevant procurement/sourcing/operations/quality functions
5. Drafts personalized, capability-aware outreach via an LLM
6. Syncs every qualifying company, contact, and outreach draft into a HubSpot CRM, with safe upsert logic for both known-email and no-email contacts

## Why

Built as a hands-on capstone for a personal transition from full-stack software engineering (React/Spring Boot) toward Applied AI / GTM Engineering roles — with the added goal of creating real, measurable impact for a real business, and a genuine, evidence-backed story for both job interviews and MBA applications.

## Results

- **126 real prospect contacts** pushed to HubSpot, across 5 countries (India, UK, UAE, Germany, Italy) and 4 product categories (appliances/electronics, HVAC, furniture, automotive)
- Built and validated across two phases: a dummy-data mechanical build, then a full BDE-data (real business input) production run
- Every major dead end (job postings signal, an "Industrial Machinery" search category, South Korea as a market, a broad EU search) was tested, diagnosed, and documented — not just the wins

## Stack

- **Orchestration:** n8n (self-hosted; developed and run locally via WSL/Docker, exposed for external calls via ngrok for this project's timeline — see `docs/decisions.md` for the full self-host vs. managed-hosting cost analysis)
- **Enrichment:** Clay — Company Search, structured-output AI Fit Scoring (GPT-4.1 mini), Find Contacts, Email Waterfall (multi-provider), Google News search + AI summarization for opportunity signals
- **Personalization:** GPT-4.1 mini via OpenAI API for the deployed pipeline; Ollama/Phi-4-mini evaluated locally for cost/quality comparison (see decisions log)
- **CRM:** HubSpot — Company, Contact, and Note objects, with a custom Search→Create/Update pattern where HubSpot's native node lacked an upsert operation
- **Intake data:** Airtable, fed by 4 n8n-hosted intake forms

## Structure

```
gtm-ai-automation-portfolio/
├── README.md
├── n8n-workflows/     # exported workflow JSON (4 intake forms + the outreach/personalization pipeline)
├── scripts/           # standalone scripts (LLM API calls, utilities)
├── infra/             # Terraform config, Docker Compose, VM setup notes
├── docs/
│   ├── architecture.md              # how the pieces connect
│   ├── build-log.md                 # working log
│   ├── decisions.md                 # every major tradeoff and why — start here for context
│   ├── airtable_setup_plan.md       # intake data schema
│   └── n8n_airtable_integration_plan.md
└── data/               # schema/sample data only — never real customer data
```

See [`docs/decisions.md`](docs/decisions.md) for the full reasoning behind every major choice made on this project — infra tradeoffs, prompt design, real bugs hit and fixed, and honestly-documented dead ends.

## Note on data privacy

This repo contains no real customer, contact, or prospect data. All examples in `data/` are synthetic or schema-only. Real business context (Atharva's capabilities, certifications, and customer categories) is described only in aggregate/public terms.

## What's next (v2 candidates, not yet built)

- Opportunity-signal linkage into personalization (built and tested, but disconnected before final deployment due to a Clay-side integration bug — see decisions log)
- RFQ/tender inbound monitoring — researched, found infeasible for private-OEM sourcing (see decisions log)
- A feedback loop tying real outreach outcomes back into Fit Score tuning