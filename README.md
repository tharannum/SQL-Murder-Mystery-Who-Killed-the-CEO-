## 🔪 SQL Murder Mystery: Who Killed the CEO?

  This repository contains the SQL queries and findings used to solve the "Who Killed the CEO of TechNova Inc.?" murder mystery.
 The case was solved by analysing various corporate data logs, including keycard entries, phone call records, alibis, and physical evidence reports.

-----

### 🎯 Mission

 The goal was to use **only SQL queries** to determine the killer, the location, the time, and the circumstances of the crime .

  *  **Victim:** CEO of TechNova Inc.  
  *  **Reported Time of Death:** October 15, 2025, at 9:00 PM  
  *  **Role:** Lead Data Analyst  

-----

### 💾 Database Schema (Assumed)

The investigation relied on joining and querying the following logical tables:

| Table Name | Description | Key Columns |
| :--- | :--- | :--- |
| `employees` | Contains employee personal details. |  `employee_id`, `name`, `department`, `role`   |
| `keycard_logs` | Records all employee entries and exits. |  `employee_id`, `room`, `entry_time`, `exit_time`   |
| `alibis` | Recorded statements from suspects about their whereabouts. |  `employee_id`, `claimed_location`, `claim_time`   |
| `calls` | Records all internal and external phone calls. | `caller_id`, `receiver_id`, `call_time`, `duration_sec`   |
| `evidence` | Records details of physical evidence found at the scene. |  `room`, `description`, `found_time`   |

-----

### 🔍 Investigation Steps and Queries

The following steps were taken to narrow down the suspect and solve the case.

#### 1\. Identify Crime Details

 The initial query identified the precise crime location and the key time of entry into the CEO's office .

```sql
-- Identify where and when the crime happened
SELECT room AS crime_location,
       entry_time AS crime_time 
FROM keycard_logs
WHERE room = 'CEO Office'
ORDER BY entry_time;
```

 **Result:** `CEO Office` at `2025-10-15 20:50:00`.
#### 2\. Analyze Access Logs

 This step identified all personnel who accessed the **CEO Office** during the critical 10-minute window (20:50:00 to 21:00:00).

```sql
-- Analyze who accessed critical areas at the time
SELECT e.employee_id, e.name, e.department, e.role, k.room, k.entry_time, k.exit_time
FROM employees AS e
JOIN keycard_logs AS k
ON e.employee_id = k.employee_id
WHERE entry_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:00:00' AND k.room = 'CEO Office';
```

 **Primary Suspect Identified:** **David Kumar**.

#### 3\. Cross-Check Alibi

This complex query compared the suspect's claimed alibi with their actual keycard log entry at the time of the crime.

```sql
-- Cross-check alibis with actual logs (Query omitted for brevity, see source lines 31-59 for full CTEs)
SELECT e.name AS employee_name, a.claimed_location, l.actual_location, l.entry_time
FROM alibis a
... -- Joins omitted
```

 **Contradiction Found:** **David Kumar** claimed to be in the **Server Room** at 20:50:00, but the logs placed him in the **CEO Office** 
#### 4\. Investigate Suspicious Calls
 
 The next step searched for any phone calls made by the primary suspect during the time they were in the CEO Office.

```sql
-- Investigate suspicious calls made around the time
SELECT e.name AS caller_name, call_time, duration_sec, e2.name AS call_reciver
FROM calls c
JOIN employees e ON c.caller_id = e.employee_id
JOIN employees e2 ON c.receiver_id = e2.employee_id
WHERE call_time BETWEEN '2025-10-15 20:50:00' AND '2025-10-15 21:00:00';
```

 **Activity Confirmed:** **David Kumar** called **Alice Johnson** at **20:55:00** 

#### 5\. Match Evidence

 This query correlated physical evidence found in the CEO Office with the suspect's movements and contradictory alibi.
```sql
-- Match evidence with movements and claims (Query omitted for brevity, see source lines 73-94)
SELECT ev.description, e.name AS suspect_name, a.claimed_location, kl.room AS actual_location
FROM evidence ev
... -- Joins and WHERE clauses omitted
WHERE ev.room = 'CEO Office' AND kl.entry_time BETWEEN '2025-10-15 20:45:00' AND '2025-10-15 21:15:00';
```

 **Evidence Confirmed:** **Fingerprint on desk** and **Keycard swipe logs mismatch** found in the CEO Office were linked to **David Kumar** 
### ✅ The Final Verdict

 By combining the finding that the suspect was logged in the crime scene at the critical time, lied about their location in their alibi, and was linked to physical evidence (including a logs mismatch suggesting a cover-up), the killer was identified 

```sql
-- Combine all findings to identify the killer (Query omitted for brevity, see source lines 96-113)
SELECT e.name 
FROM cte_find_killer a
JOIN cte_key_card AS k ON a.employee_id = k.employee_id
LEFT JOIN employees e ON a.employee_id = e.employee_id;
```

**The Killer:** **David Kumar** 

-----

### How to Run This

(Assuming a standard SQL environment like SQLite, MySQL, or PostgreSQL)

1.  **Create the Database:** Use your SQL client to create the database tables (`employees`, `keycard_logs`, `alibis`, `calls`, `evidence`).
2.  **Populate Data:** Insert the crime data into the tables (data not provided in this file, but assumed to exist based on the results).
3.  **Execute Queries:** Run the queries provided in the `Investigation Steps and Queries` section to follow the logic and solve the mystery yourself.

-----

I hope this file helps you or others understand the data analysis behind solving the case\! Would you like me to generate a simple set of **CREATE TABLE** statements based on the schema?
