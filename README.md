# Enrollment Dashboard (Personal Project — Power BI)

## What this project is
A practice project to learn Power BI, Power Query (M), and DAX by building
a small enrollment-trend dashboard. The data is synthetic (made up by a
script (not real institutional data), styled to look like a typical
term-by-term enrollment export.

## What's inside
- `generate_enrollment_data.py` — creates the synthetic dataset
- `enrollment_data.csv` — the generated dataset (67 rows: term, campus,
  program, school, enrolled/withdrew/completed counts)
- `power_query_transformations.m` — the Power Query steps used to shape the
  data (reference only — see note below)
- `dax_measures.txt` — the DAX measures used in the dashboard
- `dashboard_screenshot.png` — add this yourself once you've built the
  dashboard (see step 5 below)

## Important: this is a starting point, not a finished .pbix
Power BI dashboards are built and saved in Power BI Desktop, a Windows/Mac
application — they can't be generated as code. 

### Step 1 — Get the data in
Open Power BI Desktop → Get Data → Text/CSV → select `enrollment_data.csv`.

### Step 2 — Shape it in Power Query
Click "Transform Data" to open Power Query. Try to recreate these steps
yourself using the UI (this is the part that actually teaches you Power
Query):
1. Set correct data types on each column
2. Split the `term` column into `Term Year` and `Term Season` (Split Column
   by Delimiter, space)
3. Add a custom column `Withdrawal Rate` = `students_withdrew / students_enrolled`
4. Remove the `record_id` column
5. Rename columns to friendly names (e.g., `campus` → `Campus`)

Once you've tried it yourself, compare your steps to
`power_query_transformations.m` (open it in the Advanced Editor to see the
generated M code, or just read it as a reference).

### Step 3 — Add the DAX measures
In the Data pane, right-click the Enrollment table → New Measure. Add each
measure from `dax_measures.txt` one at a time. Start with `Total Enrolled`,
`Total Withdrew`, and `Overall Withdrawal Rate` — those three alone are
enough for a first working dashboard.

### Step 4 — Build the report page
Suggested visuals:
- Card visuals: Total Enrolled, Overall Withdrawal Rate, Completion Rate
- Bar chart: Total Enrolled by Program
- Line chart: Total Enrolled by Term (Term Year + Term Season on the axis)
- Matrix: Campus (rows) × Term (columns), values = Total Enrolled
- Slicers: Campus, School, Term

### Step 5 — Save and screenshot
Save as `enrollment_dashboard.pbix`. Take a screenshot of the finished
report page and save it in this folder as `dashboard_screenshot.png` before
You push the project to GitHub — a screenshot is what shows up when someone
looks at the repo, since GitHub can't preview .pbix files directly.

## What this demonstrates
- Power Query (M) data shaping: type conversion, column splitting, custom
  columns, renaming
- DAX measures: SUM, DIVIDE (safe division), CALCULATE, time comparison,
  TOPN
- Dashboard design choices for an audience that needs to scan results
  quickly (cards for headline numbers, trend line for change over time)

