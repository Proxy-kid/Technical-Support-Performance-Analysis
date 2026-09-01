# Technical-Support-Performance-Analysis
# Technical Support Performance Analysis

![Project Status](https://img.shields.io/badge/Status-Complete-success)
![Excel](https://img.shields.io/badge/Excel-Data%20Cleaning-217346)
![MySQL](https://img.shields.io/badge/MySQL-Analysis-4479A1)
![Tableau](https://img.shields.io/badge/Tableau-Dashboard-E97627)

## Executive Summary

This project analyzes a 2023 technical support operation containing
**2,330 support tickets**. The objective was to evaluate support demand,
operational efficiency, SLA performance, agent performance, and customer
satisfaction, then translate the findings into management-focused
recommendations.

**Workflow:** Excel data cleaning → MySQL analysis → Tableau
visualization → Business recommendations

### Core business question

> **How effectively is the technical support operation serving
> customers, where are the main performance gaps, and where should
> management prioritize improvement?**

The analysis shows a support operation with stronger first-response
performance than resolution performance. Support demand is concentrated
in a small number of topics, while resolution SLA performance declines
over the year. Average customer satisfaction is **3.5/5**. The analysis
did not identify a clear negative relationship between resolution speed
and CSAT in the observed data.

------------------------------------------------------------------------

## Business Objectives

-   Understand where support demand is concentrated.
-   Identify the products, topics, and channels generating the greatest
    workload.
-   Measure first-response and resolution performance.
-   Identify delays between resolution and formal closure.
-   Evaluate first-response and resolution SLA compliance.
-   Identify factors associated with resolution SLA violations.
-   Compare performance across agents and support teams.
-   Examine SLA performance alongside customer satisfaction.
-   Identify areas where management should prioritize operational
    improvement.

------------------------------------------------------------------------

## Business Questions

### Support Demand & Workload

1.  Where is support demand concentrated by topic?
2.  Which product groups generate the most support tickets?
3.  Which support channels handle the greatest workload?

### Support Efficiency

4.  How quickly does the support team respond to customers?
5.  How quickly are support tickets resolved?
6.  Are there delays between resolving a ticket and formally closing it?

### SLA Performance

7.  What percentage of tickets meet the first-response SLA?
8.  What percentage of tickets meet the resolution SLA?
9.  Which factors are associated with resolution SLA violations?

### Agent Performance & Customer Experience

10. How does support performance vary across agents and support teams?
11. Is slower resolution associated with lower customer satisfaction?
12. Does SLA compliance correspond with higher customer satisfaction?

------------------------------------------------------------------------

# Data Preparation

The dataset contains **2,330 technical support tickets** with
operational, SLA, agent, product, channel, geographic, and
customer-satisfaction fields.

### Excel cleaning

The cleaning stage included:

- Duplicate and missing Ticket ID checks.
  ![Checking for duplicates](excel./duplicates.png)

- Standardization of inconsistent categorical values.
   ![find_and_replace](excel./find_and_replace.png)
-   Whitespace and capitalization cleanup.
-   Timestamp chronology validation and formatting.
  ![Timestamp chronology validation and formatting](excel./time_formating.png)

-   Data-quality flags for invalid response, resolution, and close
    timestamps.
-   Preservation of legitimate missing values.
-   Retention of original source SLA statuses while separately flagging
    invalid timestamps.

The expected event sequence was:

**Created → First Response → Resolution → Close**

Therefore:

-   First response must not precede ticket creation.
-   Resolution must not precede ticket creation.
-   Close time must not precede resolution.

Invalid timestamps were **flagged rather than overwritten**. A faulty
timestamp does not automatically make the entire ticket unusable; the
ticket can still contain valid operational information.

------------------------------------------------------------------------

## 🛠 Tools Used
| Tool | Purpose |
|------|---------|
| **Microsoft Excel**  | Data cleaning, standardization,  validation and quality checks |
| **MySQL** | Exploratory Data Analysis, KPI calculation and diagnostic analysis |
| **Tableau Public** | Interactive dashboard and data visualization |
| **GitHub** | Version control and project documentation |

  -----------------------------------------------------------------------



### SQL techniques

-   Aggregations and `GROUP BY`
-   Conditional aggregation
-   `CASE`
-   CTEs
-   Window functions
-   `TIMESTAMPDIFF`
-   Date functions
-   KPI calculations
-   Data-quality filtering

------------------------------------------------------------------------

# Key Findings


### 1. Support Demand & Workload

**Where is demand concentrated, and which channels carry the load?**

  | Topic                    |    Tickets | Share |
  |-------------------------- |--------- |--------|
  | Product setup             |     630 | 27% |
  | Pricing and licensing     |     525  |  23% |
  | Feature request            |      417 |  18% |
  | Purchasing and invoicing   |      264  | 11% |

Product setup, pricing and licensing, and feature requests represent the
largest support-demand areas.

- **Product:** *Ready to use Software* generates the most tickets (43%), well ahead of *Custom software development* (28%).
- **Channel:** *Email* carries the heaviest load (53% of tickets), with *Chat* at 37% and *Phone* the smallest share at 11%.

**Business implication:**  Support demand is concentrated in a handful of topics and products. These topics provide strong opportunities for
reducing avoidable support demand through improved onboarding,
documentation, FAQs, troubleshooting resources, and product education.

------------------------------------------------------------------------

## 2. First-response performance is stronger than resolution performance

  KPI                         Result
  -------------------- -------------
  Total tickets            **2,330**
  Resolved tickets         **1,912**
  Resolution rate          **82.1%**
  First-response SLA         **87%**
  Resolution SLA             **81%**
  Average CSAT           **3.5 / 5**

The **6-percentage-point gap** between first-response SLA and resolution
SLA indicates that the larger operational challenge occurs after the
initial response: moving tickets through the process to final resolution
within the required SLA.

------------------------------------------------------------------------

## 3. Resolution SLA performance deteriorates during the year

The monthly resolution-SLA analysis shows a decline from approximately
**87% early in the year to 72% toward year-end**.

**Business implication:** Management should investigate whether the
deterioration is associated with changes in ticket volume, ticket
complexity, topic mix, product mix, priority distribution, workload, or
escalation processes.

------------------------------------------------------------------------

## 4. Resolution SLA violations occur across multiple operational dimensions

Resolution SLA performance was compared across:

-   Priority
-   Topic
-   Product group
-   Support channel
-   Support level
-   Agent group

This moves the analysis beyond simply reporting an overall SLA rate and
helps identify where operational failures are concentrated.

------------------------------------------------------------------------

## 5. Agent performance requires a balanced view

Agent analysis combines:

-   Tickets handled
-   First-response SLA compliance
-   Resolution SLA compliance
-   Resolution time
-   Agent interactions
-   CSAT

This avoids judging agents using ticket volume alone.

Agent-level differences should still be interpreted carefully because
the analysis does not fully control for ticket complexity and workload
mix.

------------------------------------------------------------------------

## 6. Resolution speed does not clearly explain CSAT

Resolution time was grouped into time bands and compared with average
CSAT.

The analysis did **not identify a clear pattern in which progressively
slower resolution consistently resulted in lower customer
satisfaction**.

This does not prove that resolution speed has no effect on satisfaction.
It means that resolution speed alone did not explain the observed CSAT
differences in this dataset.

------------------------------------------------------------------------

## 7. SLA performance should be considered alongside customer experience

Customer satisfaction was compared between tickets resolved within SLA
and tickets where the resolution SLA was violated.

This connects operational performance to the customer experience and
provides a basis for determining whether SLA improvement is also
associated with better customer outcomes.

------------------------------------------------------------------------

# Management Recommendations

### 1. Reduce avoidable demand from high-volume topics

Prioritize **Product setup**, **Pricing and licensing**, and **Feature
requests**.

Potential actions:

-   Improve onboarding documentation.
-   Expand self-service resources.
-   Create troubleshooting guides.
-   Improve product FAQs.
-   Investigate recurring product-related issues.

### 2. Focus on the resolution stage

The operation responds within SLA more often than it resolves within
SLA.

Management should investigate:

-   Escalation delays.
-   Ticket complexity.
-   Tier 1/Tier 2 workload.
-   Agent capacity.
-   Product-specific issues.
-   Resolution workflows.

### 3. Investigate the year-end SLA deterioration

Compare monthly changes in:

-   Ticket volume.
-   Priority mix.
-   Topic mix.
-   Product mix.
-   Support level.
-   Agent workload.

### 4. Use CSAT as a complementary outcome metric

A high-volume area with poor SLA performance and low CSAT should receive
more attention than an area with a high violation rate but very few
tickets.

### 5. Avoid single-metric performance decisions

Agent and team performance should be assessed using:

**Volume + SLA + Resolution Time + Interactions + CSAT**

This provides a more balanced view of performance.

------------------------------------------------------------------------

# Tableau Dashboard

## Technical Support Performance Dashboard

The dashboard provides an executive view of:

-   Total ticket volume
-   Resolved tickets
-   First-response SLA
-   Resolution SLA
-   Average CSAT
-   Ticket volume trends
-   Ticket status
-   Ticket priority
-   Top support topics
-   Support channel distribution
-   SLA compliance trends
-   CSAT trends
-   Interactive support filters

The dashboard is designed to answer:

> **What is happening in the support operation, where is performance
> weakening, and which areas deserve management attention?**

**Tableau Public:** Add your published Tableau URL here.

------------------------------------------------------------------------

# Conclusion

The analysis indicates a support operation that is **stronger at
responding to customers than at resolving tickets within SLA**.

The most important operational signal is the difference between **87%
first-response SLA and 81% resolution SLA**, together with the
deterioration in resolution SLA performance during the year.

Support demand is also concentrated in a small number of topics,
particularly **Product setup, Pricing and licensing, and Feature
requests**. These areas offer opportunities to reduce support workload
through better documentation, onboarding, self-service, and product
education.

Average CSAT is **3.5/5**, but the analysis does not show a clear
negative relationship between resolution speed and customer
satisfaction. Therefore, improving customer experience should not rely
solely on reducing resolution time; management should also investigate
issue type, communication, resolution quality, product problems, and SLA
performance.

### Overall management priority

> **Improve the resolution stage of the support process while reducing
> avoidable demand from high-volume support topics, and use SLA
> performance together with workload and CSAT to identify the
> highest-impact areas for intervention.**

------------------------------------------------------------------------

# Project Structure

``` text
technical-support-performance/
│
├── data/
│   └── technical_support_dataset.csv
│
├── sql/
│   └── technical_support_analysis.sql
│
├── dashboard/
│   └── technical_support_dashboard.png
│
└── README.md
```

------------------------------------------------------------------------

# Skills Demonstrated

### Data Preparation

-   Excel data cleaning
-   Data validation
-   Timestamp validation
-   Missing-value assessment
-   Categorical standardization
-   Data-quality flagging

### SQL

-   Aggregation
-   Conditional aggregation
-   CTEs
-   Window functions
-   Date/time analysis
-   KPI development
-   Diagnostic analysis

### Tableau

-   Executive KPI design
-   Trend analysis
-   Comparative visualizations
-   Interactive filtering
-   Dashboard layout
-   Data storytelling

### Business Analysis

-   Translating business problems into analytical questions
-   Operational performance analysis
-   SLA analysis
-   Customer-experience analysis
-   Insight generation
-   Management recommendations
-   Communicating analytical limitations

------------------------------------------------------------------------

# Author

**Baasey Akan**

Aspiring Data Analyst

-   GitHub: https://github.com/Proxy-kid
-   LinkedIn: https://www.linkedin.com/in/bassey-akan

------------------------------------------------------------------------

## Disclaimer

This project is a portfolio/business analytics case study. The dataset
and business scenario are presented for analytical demonstration
purposes.
