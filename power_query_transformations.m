// power_query_transformations.m
//
// This is the Power Query (M) code behind the "Enrollment" query in the
// dashboard. In Power BI Desktop, you can paste this into the Advanced
// Editor (Home > Transform Data > Advanced Editor) after connecting to
// enrollment_data.csv, or rebuild the same steps manually using the UI —
// rebuilding it by hand in the UI is the better way to actually learn
// Power Query, then compare your result to this file.
//
// Steps this performs:
// 1. Load the CSV
// 2. Set correct data types
// 3. Split "term" into Term Year and Term Season (so they can be sorted
//    and filtered separately in the dashboard)
// 4. Add a Withdrawal Rate column
// 5. Remove the row-level ID column (not needed for reporting)

let
    Source = Csv.Document(File.Contents("enrollment_data.csv"),
        [Delimiter=",", Columns=8, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),

    ChangedType = Table.TransformColumnTypes(PromotedHeaders, {
        {"record_id", Int64.Type},
        {"term", type text},
        {"campus", type text},
        {"program", type text},
        {"school", type text},
        {"students_enrolled", Int64.Type},
        {"students_withdrew", Int64.Type},
        {"students_completed_term", Int64.Type}
    }),

    // Split "2025 Fall" into "2025" and "Fall" as two columns
    SplitTerm = Table.SplitColumn(ChangedType, "term",
        Splitter.SplitTextByDelimiter(" ", QuoteStyle.Csv),
        {"Term Year", "Term Season"}),

    ChangedSplitTypes = Table.TransformColumnTypes(SplitTerm, {
        {"Term Year", Int64.Type},
        {"Term Season", type text}
    }),

    // Withdrawal Rate = withdrawals / enrolled, as a percentage
    AddedWithdrawalRate = Table.AddColumn(ChangedSplitTypes, "Withdrawal Rate",
        each if [students_enrolled] = 0 then 0
             else [students_withdrew] / [students_enrolled],
        type number),

    RemovedID = Table.RemoveColumns(AddedWithdrawalRate, {"record_id"}),

    RenamedColumns = Table.RenameColumns(RemovedID, {
        {"campus", "Campus"},
        {"program", "Program"},
        {"school", "School"},
        {"students_enrolled", "Students Enrolled"},
        {"students_withdrew", "Students Withdrew"},
        {"students_completed_term", "Students Completed Term"}
    })

in
    RenamedColumns
