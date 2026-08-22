# Airtable — Full Select/Multi-Select Options Reference

Go through every column below in Airtable's field editor and paste in the full option list. This fixes the "expects one of the following values: []" error across the whole base in one pass, rather than hitting it field-by-field as each chapter is tested. Typecast will NOT auto-fix this — confirmed broken for the Create-or-Update node in current n8n.

---

## Chapter 1 (Single Select fields)
- **Ch1 - Current Capacity Utilization**: Running near-max, Some headroom, Significant headroom, Not sure
- **Ch1 - Workforce count (incl. contract)**: 50-100, 101-250, 251-500, 500+
- **Ch1 - Typical lead time**: Under 2 weeks, 2-4 weeks, 4-8 weeks, 8+ weeks, Varies significantly by order
- **Ch1 - Tool room/design still accurate?**: Yes, still accurate, No, this has changed
- **Ch1 - Minimum order quantity**: Yes, fixed MOQ, Varies by customer/product, No MOQ
- **Ch1 - Currently exporting?**: Yes, currently exporting, No, Planning to

## Chapter 1 (Multiple Select fields)
- **Ch1 - Materials & Gauge Range**: GL/GPSP, Aluminium (0.25-2mm) / aluminium-coated steel, HR/CR steel (up to 16mm), SS304/SS430 (up to 2mm), ERW pipes (OD 25-82mm / up to 5mm thick)
- **Ch1 - Additional in-house capabilities**: Welding (Manual & Robotic), CNC Tube bending/squeezing/flaring, Tool Room, Designing (SolidWorks/AutoCAD)
- **Ch1 - Quality Certifications**: IATF 16949:2016, ISO 9001:2015, Other
- **Ch1 - Certifications in progress**: ISO 14001 (Environmental), OHSAS/ISO 45001 (Safety), Additional customer-specific approvals, None currently, Other
- **Ch1 - Specialized/differentiating equipment**: FARO Arm & CMM metrology, Robotic welding lines, Other
- **Ch1 - Export/import compliance certs**: Not sure / need to confirm, AEO (Authorized Economic Operator), Other

---

## Chapter 2 (Single Select fields)
- **Ch2 - Who owns BD day-to-day**: Director, Dedicated BD Lead, A small team, Other
- **Ch2 - CRM/tool used**: Dedicated CRM, Spreadsheet, Nothing formal yet, Other
- **Ch2 - How quotes generated**: Manual (Excel/Word), Semi-automated, Dedicated software, Ad hoc, no fixed process
- **Ch2 - Inquiries per month**: 0-5, 5-15, 15-30, 30+
- **Ch2 - Conversion rate**: Under 10%, 10-25%, 25-50%, Over 50%, Not sure
- **Ch2 - Active pipeline size**: Under 10, 10-25, 25-50, 50+
- **Ch2 - Sales cycle length**: Under 1 month, 1-3 months, 3-6 months, 6+ months
- **Ch2 - Pricing model**: Per-piece, Tooling-inclusive, Cost-plus, Market-rate, Mixed, Other
- **Ch2 - Payment terms**: Net 30, Net 45, Net 60, Net 90, Other
- **Ch2 - Pricing flexibility (strategic accounts)**: Yes, regularly, Case-by-case, Rarely, No
- **Ch2 - Revenue share, top 2-3 customers**: Under 25%, 25-50%, 50-75%, Over 75%
- **Ch2 - Price sensitivity**: Very price-sensitive, Moderately price-sensitive, Prioritize quality & reliability over price, Varies by customer

## Chapter 2 (Multiple Select fields)
- **Ch2 - Customer comms tracked**: Email, WhatsApp Business, Phone (unlogged), CRM notes, Not tracked formally, Other
- **Ch2 - Other digital presence**: Company LinkedIn page, IndiaMART, TradeIndia, Justdial, None of these, Other
- **Ch2 - How prospects find you**: Referrals, RFQs & tenders, Distributors, Trade shows, Cold outreach, Other
- **Ch2 - Required during sales process**: Formal quote, Physical samples, Capability deck, Facility audit, Reference checks, Other
- **Ch2 - Who makes final decision (customer side)**: Procurement, Engineering, Plant head, Owner/founder, Committee, Other
- **Ch2 - Biggest edge over competitors**: Price, Quality, Turnaround time, Certifications, Existing relationships, Location, Other
- **Ch2 - What competitors do better**: Price, Speed, Quality, Relationships, Nothing significant, Other

---

## Chapter 3 (Single Select fields)
- **Ch3 - Check-in cadence**: Monthly, Quarterly, Annually, No set cadence
- **Ch3 - How stay in touch**: Regular scheduled visits/calls, As-needed only, Mostly transactional, Other
- **Ch3 - Tried upsell/cross-sell**: Yes, works well, Yes, mixed results, Haven't tried, Other
- **Ch3 - Leads fall through cracks**: Rarely, Sometimes, Often, Not sure
- **Ch3 - Biggest bottleneck**: Not enough leads coming in, Slow quote turnaround, Losing RFQs to competitors, No time for proactive outreach, No system to track follow-ups, Other

## Chapter 3 (Multiple Select fields)
- **Ch3 - Recurring reasons deals lost**: Price, Speed, Certification/compliance gap, Trust/relationship, Quality concerns, Other
- **Ch3 - New industries/geographies**: Automotive, Consumer Appliances, Electricals & Electronics, HVAC, Furniture, Medical, Industrial Equipment, Aerospace & Defense, Renewable Energy, New export markets, Other

---

## Chapter 4 (Single Select fields)
- **Ch4 - Primary BD/sales decision-maker**: Director, Dedicated BD Lead, Other
- **Ch4 - Comfort with digital tools**: Very comfortable, Somewhat comfortable, Not very comfortable, Resistant
- **Ch4 - Tried CRM that didn't stick**: Yes, and it stuck, Yes, but didn't stick, Never tried
- **Ch4 - Who would operate it day-to-day**: Owner, A dedicated BD person, Someone else
- **Ch4 - Open to systematic vs. relationship-driven**: Fully embrace a structured approach, Open, but cautious, Prefer to keep it relationship/instinct-driven, Not sure

## Chapter 4 (Multiple Select fields)
- **Ch4 - KPIs/targets tracked**: Revenue growth, New customer count, Conversion rate, None currently, Other

---

## Quick unblock (do this first, right now)

To get past the immediate error and continue testing Chapter 1: open **Ch1 - Current Capacity Utilization** in Airtable, confirm/change its type to Single Select, and add the 4 options listed above. That single fix unblocks your current test. Do the rest of the fields above before running full tests across Chapters 2-4, or you'll hit this same error repeatedly, one field at a time.
