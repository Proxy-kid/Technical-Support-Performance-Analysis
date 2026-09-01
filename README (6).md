# Technical Support Performance Analysis

**Author:** Akan the Analyst (Bassey)
**Tools:** MySQL · Tableau · Excel/Python (data preparation)
**Dataset:** 2,330 support tickets — Email, Chat, and Phone channels

## Project Overview

This project analyzes a year of technical support ticket data to understand how the support team performs on speed, SLA compliance, and customer satisfaction — and where the gaps are. The workflow covers the full pipeline: cleaning and re-engineering the raw dataset, loading it into MySQL, running exploratory SQL analysis, and building an executive dashboard in Tableau.

**Files in this project:**
| File | Purpose |
|---|---|
| `customer_support.csv` | Cleaned, enhanced ticket-level dataset |
| `create_technical_support_table.sql` | Table schema + data import script (MySQL) |
| `technical_support_eda.sql` | Exploratory SQL analysis answering the business questions below |
| `Dashboard_1.png` | Tableau executive dashboard |

## Headline Numbers

| Metric | Value |
|---|---|
| Total tickets | 2,330 |
| Resolved or closed | 1,912 (82.1%) |
| First Response SLA compliance | 87% |
| Resolution SLA compliance | 81% |
| Average CSAT | 3.5 / 5 |

## Business Questions & Findings

### 1. Support Demand & Workload

**Where is demand concentrated, and which channels carry the load?**

- **Topic:** *Product setup* drives the most tickets (27%), followed by *Pricing and licensing* (20%) and *Feature request* (18%) — together nearly two-thirds of all volume.
- **Product:** *Ready to use Software* generates the most tickets (43%), well ahead of *Custom software development* (28%).
- **Channel:** *Email* carries the heaviest load (53% of tickets), with *Chat* at 37% and *Phone* the smallest share at 11%.

**Takeaway:** Support demand is concentrated in a handful of topics and products — a knowledge-base or self-service fix targeted at "Product setup" and "Pricing and licensing" would reduce the largest share of incoming volume.

### 2. Support Efficiency

**How fast does the team respond and resolve, and where do delays creep in?**

- **First response speed by channel:** Chat (1.9 min) and Phone (5.3 min) are answered almost instantly; Email lags far behind at **48.4 minutes** on average — a real gap given Email is also the highest-volume channel.
- **Resolution speed:** Averages roughly 30–39 hours across topics and priorities, with *Bug report* (29.9 hrs) resolved fastest and *Training request* (38.9 hrs) slowest. Priority level barely moves resolution time (Low: 32.2 hrs, High: 33.2 hrs, Medium: 34.9 hrs) — **High-priority tickets are not being resolved meaningfully faster than Low-priority ones**, which is worth flagging operationally.
- **Resolution-to-close lag:** Once a ticket is resolved, it sits **59–70 more hours** before being formally closed, with Chat tickets waiting longest (69.7 hrs). This is pure administrative delay after the actual fix — a process-tightening opportunity that costs nothing to implement.

### 3. SLA Performance

**How well is the team hitting its response and resolution targets, and what predicts a miss?**

- **First Response SLA:** 87% met overall. Email performs best (91.8% within SLA) despite being the slowest channel in raw minutes — its SLA window is simply set looser. Phone has the weakest compliance (75%) even though it responds fastest in absolute terms, meaning its SLA target is tighter relative to typical handling time.
- **Resolution SLA:** 81% met overall. 2nd-line support slightly outperforms 1st-line (83.4% vs 80.0%).
- **What predicts a violation:** Priority is *not* the main driver — Medium-priority tickets violate resolution SLA most often (21.6%), slightly ahead of Low (18.4%) and High (17.0%). Tier 1 support has a higher violation rate (20.0%) than Tier 2 (16.6%).

**Takeaway:** SLA misses aren't concentrated where you'd expect (urgent tickets) — they're spread fairly evenly, and Medium-priority tickets are actually the weakest performers. This suggests a triage/workload issue rather than a difficulty issue.

### 4. Agent Performance & Customer Experience

**How does performance vary by agent, and does speed or SLA compliance actually drive satisfaction?**

- **Agent spread:** Resolution SLA compliance ranges from 87.1% (Heather Urry) down to 78.4% (Connor Danielovitch) across the 8 agents — roughly a 9-point gap between the best and weakest performer on the same metric.
- **Does faster resolution improve CSAT?** No — the data does not show this. CSAT is essentially flat across resolution-speed buckets (3.42 for tickets resolved in 0–4 hours vs **3.62 for tickets that took 49+ hours** — the slowest bucket actually scores highest).
- **Does SLA compliance improve CSAT?** No — tickets where the resolution SLA was *violated* scored slightly **higher** CSAT (3.60) than tickets resolved within SLA (3.49).

**Takeaway:** This is the most important — and most counter-intuitive — finding in the analysis. Speed and SLA compliance, as currently measured, are not what's driving customer satisfaction. CSAT is likely being shaped by something else entirely (how the issue was resolved, communication quality, first-contact resolution, agent tone) rather than the clock. Chasing faster resolution times alone will not move satisfaction scores — the team should investigate qualitative drivers of CSAT before over-indexing on speed metrics.

## Data Notes

- Analysis excludes tickets flagged by the data-quality checks (`Response Check`, `Resolution check`, `Close time check`) built during cleaning — these catch the handful of tickets with impossible timestamp ordering (e.g., resolved before first response) so they don't distort averages.
- CSAT (`Survey Result`) is only available for 1,173 of 2,330 tickets (customers who completed the post-resolution survey); all CSAT figures above are averaged over responses only, not the full ticket base.
- Two `Topic` values differ only by capitalization ("Pricing and Licensing" vs "Pricing and licensing") in the source data — worth standardizing in a future cleaning pass, as it currently splits one topic into two rows in some groupings.

## Recommendations

1. **Target the top topics** (Product setup, Pricing and licensing) with self-service content to cut ticket volume at the source.
2. **Investigate the Email response gap** — 48 minutes to first response vs under 6 minutes for Chat/Phone is a large, actionable gap on the highest-volume channel.
3. **Audit Medium-priority triage** — it has the worst resolution SLA compliance despite not being the most urgent tier.
4. **Close the resolve-to-close gap** — 59–70 hours of pure administrative lag after a ticket is already fixed is process waste, not workload.
5. **Don't optimize CSAT via speed alone** — since faster/SLA-compliant tickets don't score higher satisfaction, pair this dataset with qualitative feedback (survey comments, call transcripts) to find the real satisfaction drivers before setting new team targets.
