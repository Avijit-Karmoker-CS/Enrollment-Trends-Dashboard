"""
generate_enrollment_data.py

Creates a synthetic (fake) college enrollment dataset for practicing
Power BI dashboard building: importing data, shaping it in Power Query,
and writing DAX measures.

This is NOT real institutional data. It's built to look like a typical
term-by-term enrollment export so the Power BI steps in README.md have
something realistic to work with.
"""

import csv
import random

random.seed(7)

CAMPUSES = ["IT Campus", "Akerley Campus", "Ivany Campus", "Truro Campus", "Kingstec Campus"]
PROGRAMS = [
    ("Business Administration", "Business"),
    ("Information Technology", "Business"),
    ("Electronics Engineering Technology", "Engineering"),
    ("Practical Nursing", "Health"),
    ("Early Childhood Education", "Human Services"),
    ("Carpentry", "Trades"),
]
TERMS = ["2024 Fall", "2025 Winter", "2025 Fall", "2026 Winter"]


def generate_rows():
    rows = []
    row_id = 1
    for term in TERMS:
        for program, school in PROGRAMS:
            for campus in CAMPUSES:
                # not every program runs at every campus
                if random.random() < 0.4:
                    continue
                base = random.randint(15, 60)
                enrolled = base
                withdrew = round(base * random.uniform(0.03, 0.12))
                completed_term = enrolled - withdrew
                rows.append({
                    "record_id": row_id,
                    "term": term,
                    "campus": campus,
                    "program": program,
                    "school": school,
                    "students_enrolled": enrolled,
                    "students_withdrew": withdrew,
                    "students_completed_term": completed_term,
                })
                row_id += 1
    return rows


def main():
    rows = generate_rows()
    fieldnames = list(rows[0].keys())
    with open("enrollment_data.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    print(f"Wrote {len(rows)} rows to enrollment_data.csv")


if __name__ == "__main__":
    main()
