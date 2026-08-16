# GTM AI Automation — Capstone Project

**Status:** 🚧 In progress — kicked off 2026-08-16

## What this is

An AI-powered GTM automation pipeline built for a real business: my father's sheet-metal stamping company, which produces parts for appliance manufacturers. The company currently runs business development almost entirely through referrals and manual outreach, with no real digital/automation layer.

This project builds a pipeline that:
1. Collects structured operational data from the business (capabilities, ICP, current process) via an intake questionnaire
2. Identifies and enriches target accounts (OEMs / tier-1 suppliers) via Clay
3. Uses an LLM to draft personalized, capability-aware outreach
4. Orchestrates the whole flow via self-hosted n8n
5. Syncs qualified leads into a HubSpot CRM

## Why

Built as a hands-on capstone for a personal transition from full-stack software engineering (React/Spring Boot) toward Applied AI / GTM Engineering roles — with the added goal of creating real, measurable impact for a real business, and a genuine story for both job interviews and MBA applications.

## Stack

- **Orchestration:** n8n (self-hosted, Docker, on a free-tier cloud VM)
- **Enrichment:** Clay
- **Personalization:** Claude / OpenAI API
- **CRM:** HubSpot
- **Intake data:** Airtable / Google Sheets

## Structure

```
gtm-ai-automation-portfolio/
├── README.md
├── n8n-workflows/     # exported workflow JSON
├── scripts/           # standalone scripts (LLM API calls, utilities)
├── infra/             # Docker Compose, reverse proxy config, VM setup notes
├── docs/
│   ├── architecture.md   # how the pieces connect
│   ├── build-log.md      # working log
│   └── decisions.md      # key tradeoffs and why — start here for context
└── data/               # schema/sample data only — never real customer data
```

See [`docs/decisions.md`](docs/decisions.md) for the reasoning behind every major choice made on this project so far.

## Note on data privacy

This repo contains no real customer or business data. All examples in `data/` are synthetic or schema-only.
