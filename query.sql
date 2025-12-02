-- Identify where and when the crime happened
select room as crime_location,
entry_time as crime_time FROM keycard_logs
where room = 'CEO Office'
order by entry_time;

-- Analyze who accessed critical areas at the time
SELECT 
	e.employee_id, 
	e.name, 
	e.department, 
    e.role, 
    k.room, 
    k.entry_time, 
    k.exit_time
FROM employees as e
join keycard_logs as k
on e.employee_id = k.employee_id
where entry_time between '2025-10-15 20:50:00' and '2025-10-15 21:00:00';

-- Cross-check alibis with actual logs
 

WITH cte_alibi AS (
    SELECT 
        employee_id,
        claimed_location,
        claim_time
    FROM alibis
    WHERE claim_time = '2025-10-15 20:50:00'
),

cte_logs AS (
    SELECT
        employee_id,
        room AS actual_location,
        entry_time,
        exit_time
    FROM keycard_logs
    WHERE room = 'CEO Office'
)

SELECT
    e.name AS employee_name,
    a.claimed_location,
    a.claim_time,
    l.actual_location,
    l.entry_time,
    l.exit_time

FROM cte_alibi a
LEFT JOIN cte_logs l
    ON a.employee_id = l.employee_id
LEFT JOIN employees e
    ON a.employee_id = e.employee_id;

-- Investigate suspicious calls made around the time
SELECT 
	e.name as caller_name,
    call_time, 
    duration_sec,
    e2.name as call_reciver 
FROM calls c
join employees e
on c.caller_id = e.employee_id
join employees e2
on c.receiver_id = e2.employee_id
where call_time between '2025-10-15 20:50:00' and '2025-10-15 21:00:00';

-- Match evidence with movements and claims
SELECT 
    ev.room,
    ev.description,
    ev.found_time,
    e.name AS suspect_name,
    a.claimed_location,
    kl.room AS actual_location,
    a.claim_time,
    kl.entry_time AS actual_entry_time,
    kl.exit_time AS actual_exit_time,
    ca.call_time
FROM evidence ev
JOIN keycard_logs kl 
    ON ev.room = kl.room
JOIN alibis a 
    ON kl.employee_id = a.employee_id
JOIN employees e 
    ON e.employee_id = kl.employee_id
LEFT JOIN calls ca 
    ON ca.caller_id = e.employee_id
WHERE ev.room = 'CEO Office'
  AND kl.entry_time BETWEEN '2025-10-15 20:45:00' AND '2025-10-15 21:15:00';


-- Combine all findings to identify the killer
 with cte_find_killer as
(
select employee_id, claimed_location, claim_time
FROM alibis 
where claim_time = '2025-10-15 20:50:00'
),
cte_key_card as
(
 select employee_id, room as crime_location,
entry_time as crime_time FROM keycard_logs
where room = 'CEO Office'
order by entry_time
)
SELECT e.name as killer FROM cte_find_killer  a
join cte_key_card as k
on a.employee_id = k.employee_id
left join employees e 
on a.employee_id = e.employee_id;
    

 



 