# Participant lab manual

## Objective

Produce a correct enriched order table and defend the best CAS technique for the stated workload. Record evidence; do not assume that partitioning, an index, DVR, or compression wins.

## Agenda (3½ hours)

| Time | Lab |
|---|---|
| 0:00–0:20 | Configure, create/load, and validate data |
| 0:20–0:45 | Dimension size and plans |
| 0:45–1:10 | Functions in predicates |
| 1:10–1:35 | Wide versus lean joins |
| 1:35–1:45 | Break |
| 1:45–2:15 | Partitioning and break-even |
| 2:15–2:40 | Full versus selective indexed joins |
| 2:40–3:05 | STANDARD, DVR, and compression |
| 3:05–3:25 | Finalists and total cost |
| 3:25–3:30 | Recommendation |

## Lab 0 — Setup and evidence rules

1. Copy and edit `config/config.example.sas`.
2. Run through `30_initialize_results.sas`.
3. Confirm the input counts and that the three dimension duplicate tables are empty.
4. Record CAS worker count, data profile, run count, and start time in your notes.

**Checkpoint:** All four `_raw` CAS tables exist; dimension keys are unique.

## Lab 1 — Dimension size

Run `40_dimension_size.sas`.

Record for each lookup:

- plan nodes and number of sorts;
- evidence of replication or redistribution;
- median query time;
- result row count.

**Discuss:** Did the biggest dimension force the slowest query? What changed in the plan?

## Lab 2 — Functions in predicates

Run `41_predicate_functions.sas`.

Compare:

```sas
on upper(trim(o.Country)) = upper(trim(c.Country))
```

with:

```sas
on o.Country = c.Country
```

**Explain:** Is key normalization a recurring query cost or a data-preparation responsibility? Note both performance and semantic risk.

## Lab 3 — Column pruning

Run `42_column_pruning.sas`.

Compare the wide result with the required ten-column result. Record elapsed time, result size, stage widths, and any change in sorts/movement.

**Checkpoint:** Both results have one row per order and the same quantity total.

## Lab 4 — Partitioning

Run `43_partitioning.sas`.

Record:

- fact partition creation time;
- dimension partition creation time;
- unpartitioned and partitioned medians;
- calculated break-even count.

Compute total cost for 1, 5, and 20 uses. Reject partitioning if it saves no query time or cannot repay preparation within expected reuse.

## Lab 5 — Indexes

Run `44_indexes.sas`.

Compare indexed and unindexed customer dimensions for:

1. a full enrichment;
2. a selective fact subset controlled by `SELECTIVE_CUSTOMERS`.

Inspect whether the plan uses the index. Include index build time and storage in your decision.

## Lab 6 — Storage formats

Run `45_storage_formats.sas`.

For `result_standard`, `result_dvr`, and `result_compressed`, record memory/disk metadata and median time for the identical group-by summary.

**Discuss:** Which representation is smallest? Which is fastest to scan? Does either saving justify preparation or CPU cost?

## Lab 7 — Finalists

Run `46_finalists.sas`, then `50_validate_results.sas` and `60_export_results.sas`.

Complete this statement:

> For **[one-off/repeated/selective/memory-constrained]** workloads, we recommend **[candidate]** because it changed **[elapsed time/data movement/memory]** by **[measured amount]**. Preparation cost was **[amount]**, giving break-even at **[N]** runs. We rejected **[alternative]** because **[plan or measurement evidence]**.

## Evidence checklist

- [ ] configuration and scale recorded
- [ ] warm-up excluded from median
- [ ] five or more measured runs for conclusions
- [ ] actual plan captured
- [ ] preparation cost separated
- [ ] result correctness checked
- [ ] one-, five-, and twenty-run costs compared
- [ ] recommendation tied to workload and evidence
