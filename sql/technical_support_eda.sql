-- 1. Support Demand & Workload
/*
Q1 Where is support demand concentrated by topic?
Q2 Which products generate the most support tickets?
Q3 Which channels handle the greatest workload?
*/

-- Q1 Where is support demand concentrated by topic?
SELECT 
	topic,
    count(*) AS ticket_count,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER()) percent_ticket_count
FROM technical_support_tickets
GROUP BY topic
ORDER BY percent_ticket_count DESC;

-- Q2 Which products generate the most support tickets?
SELECT
	product_group,
	COUNT(*) AS ticket_volume,
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER()) * 100) AS percent_ticket_count
FROM technical_support_tickets
GROUP BY product_group
ORDER BY percent_ticket_count DESC;

-- Q3 Which channels handle the greatest workload?    
SELECT
	source,
	COUNT(*) AS ticket_volume,
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER()) * 100) AS percent_ticket_count
FROM technical_support_tickets
GROUP BY source
ORDER BY percent_ticket_count DESC;

-- ------------------------------------------------------------------

-- 2. Support Efficiency
/*
Q4. How quickly does the support team respond to customers?
Q5. How quickly are support tickets resolved?
Q6. Are there delays between resolving a ticket and formally closing it?
*/

-- Q4. How quickly does the support team respond to customers?
SELECT
	source,
    ROUND(AVG(first_response_minutes), 2) AS avg_first_response_mins
FROM technical_support_tickets
WHERE response_check = 'Good'
GROUP BY source;

-- Q5. How quickly are support tickets resolved?
/* 5.1 Resolution time by topic */
SELECT
	topic,
    COUNT(*) AS total_tickets_resolved,
	ROUND(AVG(resolution_hours), 2) AS AVG_resolution_time_hrs
FROM technical_support_tickets
WHERE response_check = 'Good' AND
	resolution_check = 'Good'
GROUP BY topic
ORDER BY topic DESC;

/* 5.2 Resolution time by product */
SELECT
	product_group,
    COUNT(*) AS total_tickets_resolved,
    ROUND(AVG(TIMESTAMPDIFF(SECOND, created_time, resolution_time) / 3600), 2) AS avg_resolution_hours
FROM technical_support_tickets
WHERE resolution_check = "Good"
GROUP BY product_group
ORDER BY AVG_resolution_hours;

/* 5.3 Resolution time by priority */
SELECT
	priority,
    COUNT(*) AS total_tickets_resolved,
	ROUND(AVG(resolution_hours), 2) AS AVG_resolution_time_hrs
FROM technical_support_tickets
WHERE response_check = 'Good' AND
	resolution_check = 'Good'
GROUP BY priority
ORDER BY AVG_resolution_time_hrs;

-- Q6 Are there delays between resolving a ticket and formally closing it?
SELECT
	source,
    ROUND(AVG(TIMESTAMPDIFF(SECOND, resolution_time, close_time)) / 3600, 2) AS avg_resolution_to_close_hours
FROM technical_support_tickets
WHERE resolution_check = "Good" 
	AND close_time_check = "Good"
GROUP BY source;

-- ---------------------------------------------------------------------------

/*
3. SLA Performance
Q7. What percentage of tickets meet the first-response SLA?
Q8. What percentage of tickets meet the resolution SLA?
Q9. Which factors are associated with resolution SLA violations?
*/
-- Q7. What percentage of tickets meet the first-response SLA?

--  first-response SLA by source
SELECT
    source,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN first_response_sla_status = "WITHIN SLA" THEN 1 ELSE 0 END) AS met_sla,
    SUM(CASE WHEN first_response_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS missed_sla,
    ROUND(100 * SUM(CASE WHEN first_response_sla_status = 'WITHIN SLA' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_compliance_pct
FROM technical_support_tickets
WHERE response_check = 'Good'
GROUP BY source
ORDER BY sla_compliance_pct DESC;

-- first-response SLA by topic
SELECT
    topic,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN first_response_sla_status = "WITHIN SLA" THEN 1 ELSE 0 END) AS met_sla,
    SUM(CASE WHEN first_response_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS missed_sla,
    ROUND(100 * SUM(CASE WHEN first_response_sla_status = 'WITHIN SLA' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_compliance_pct
FROM technical_support_tickets
WHERE response_check = 'Good'
GROUP BY topic
ORDER BY sla_compliance_pct DESC;

-- first-response SLA by agent_group
SELECT
    agent_group,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN first_response_sla_status = "WITHIN SLA" THEN 1 ELSE 0 END) AS met_sla,
    SUM(CASE WHEN first_response_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS missed_sla,
    ROUND(100 * SUM(CASE WHEN first_response_sla_status = 'WITHIN SLA' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_compliance_pct
FROM technical_support_tickets
WHERE response_check = 'Good'
GROUP BY agent_group
ORDER BY sla_compliance_pct DESC;

-- Q8. What percentage of tickets meet the resolution SLA?

-- resolution SLA by agent_group
SELECT
    agent_group,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status = "WITHIN SLA" THEN 1 ELSE 0 END) AS met_sla,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS missed_sla,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'WITHIN SLA' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_compliance_pct
FROM technical_support_tickets
WHERE resolution_check = 'Good' AND 
	response_check = 'Good'
GROUP BY agent_group
ORDER BY sla_compliance_pct DESC;

-- resolution SLA by topic
SELECT
    topic,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status = "WITHIN SLA" THEN 1 ELSE 0 END) AS met_sla,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS missed_sla,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'WITHIN SLA' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_compliance_pct
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY topic
ORDER BY sla_compliance_pct DESC;

-- resolution SLA by source
SELECT
    source,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status LIKE "WITHIN SLA%" THEN 1 ELSE 0 END) AS met_sla,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS missed_sla,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'WITHIN SLA' THEN 1 ELSE 0 END) / COUNT(*), 1) AS sla_compliance_pct
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY source
ORDER BY sla_compliance_pct DESC;

-- Resolution SLA by month
SELECT
    YEAR(created_time) AS year,
    MONTH(created_time) AS month,
    COUNT(*) AS total_tickets,
    SUM(resolution_sla_status = 'WITHIN SLA') AS met_sla,
    SUM(resolution_sla_status = 'SLA VIOLATED') AS sla_violations,
    ROUND(
        100 * AVG(resolution_sla_status = 'WITHIN SLA'), 1
    ) AS sla_compliance_pct
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY YEAR(created_time), MONTH(created_time)
ORDER BY year, month;



-- Q9. Which factors are associated with resolution SLA violations?

-- By Priority
SELECT
    priority,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS violations,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) / COUNT(*), 1) AS violation_pct,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hrs
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY priority
ORDER BY violation_pct DESC;

-- By Topic
SELECT
    topic,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS violations,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) / COUNT(*), 1) AS violation_pct,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hrs
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY topic
ORDER BY violation_pct DESC;

-- By Product Group
SELECT
    product_group,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS violations,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) / COUNT(*), 1) AS violation_pct,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hrs
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY product_group
ORDER BY violation_pct DESC;

-- By Source
SELECT
    source,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS violations,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) / COUNT(*), 1) AS violation_pct,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hrs
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY source
ORDER BY violation_pct DESC;

-- By Support Level
SELECT
    support_level,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS violations,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) / COUNT(*), 1) AS violation_pct,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hrs
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY support_level
ORDER BY violation_pct DESC;

-- By Agent Group
SELECT
    agent_group,
    COUNT(*) AS total_tickets,
    SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) AS violations,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'SLA VIOLATED' THEN 1 ELSE 0 END) / COUNT(*), 1) AS violation_pct,
    ROUND(AVG(resolution_hours), 2) AS avg_resolution_hrs
FROM technical_support_tickets
WHERE resolution_check = 'Good'
GROUP BY agent_group
ORDER BY violation_pct DESC;

-- ---------------------------------------------------------------------------------------------

/*
4. Agent & Team Performance, Customer Experience
Q9. How does support performance vary across agents and support teams?
Q10. Is slower resolution associated with lower customer satisfaction?
Q11. Does SLA compliance correspond with higher customer satisfaction?
*/
-- Q9. How does support performance vary across agents and support teams?
SELECT 
	agent_name,
    COUNT(*) AS ticket_handled,
    ROUND(100 * SUM(CASE WHEN first_response_sla_status LIKE '%Within SLA%' THEN 1 ELSE 0 END) / COUNT(*), 2) AS sla_compliance_pct,
    ROUND(100 * SUM(CASE WHEN resolution_sla_status = 'Within SLA' THEN 1 ELSE 0 END) / COUNT(*), 2) resolution_sla_pct,
    ROUND(AVG(resolution_hours),2) AS AVG_resolution_hrs,
    ROUND(AVG(agent_interactions), 2) AS agent_interaction,
    ROUND(AVG(survey_result),1) AS CSAT
FROM technical_support_tickets
WHERE resolution_check = "Good" 
	AND response_check = "Good"
GROUP BY agent_name
ORDER BY sla_compliance_pct DESC;

-- Q10. Is slower resolution associated with lower customer satisfaction?
WITH corr AS (
    SELECT
        created_time,
        first_response_minutes,
        survey_result,
        CASE
			WHEN resolution_hours < 5 THEN '0–4 hours'
			WHEN resolution_hours < 10 THEN '5–9 hours'
			WHEN resolution_hours < 25 THEN '10–24 hours'
			WHEN resolution_hours < 49 THEN '25–48 hours'
		ELSE '49+ hours'
END AS resolution_speed
    FROM technical_support_tickets
)
SELECT
    resolution_speed,
    ROUND(AVG(survey_result), 2) AS csat,
    COUNT(*) AS ticket_count
FROM corr
WHERE survey_result IS NOT NULL
  AND resolution_speed IS NOT NULL
GROUP BY resolution_speed
ORDER BY csat;


-- Q11. Does SLA compliance correspond with higher customer satisfaction?
SELECT
	resolution_sla_status,
    ROUND(AVG(survey_result),1) AS CSAT
FROM technical_support_tickets
WHERE resolution_check = 'Good'
  AND survey_result IS NOT NULL
GROUP BY resolution_sla_status;