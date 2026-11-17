# Case study: lookup performance in CAS

## Business problem

A retailer enriches nearly 15 million order rows with a country name, product details, and a prepared customer name. The lookup tables range from 17 rows to about 1.1 million rows. The production team needs an evidence-based layout and query pattern rather than a rule of thumb.

## Required result

One row per order containing:

- the six fact columns;
- `Country_Name`;
- `Item` and `Manufacturer`;
- `CustomerName`.

## Questions the study answers

1. Does the plan change as the dimension grows from 17 to 700 to roughly 1.1 million rows?
2. What does a function in a join predicate cost?
3. How much do unused dimension columns add to movement, memory, and output size?
4. Does co-partitioning the large fact/dimension pair save enough query time to repay its preparation cost?
5. Does a CAS index help a full join, a selective lookup, both, or neither?
6. Which representation—STANDARD, DVR, or compression—fits the downstream workload?
7. Which choice wins for one execution, five executions, and twenty executions?

## Experimental controls

- Use one CAS session and identical input rows.
- Verify dimension key uniqueness before joining.
- Run one warm-up and at least five measured repetitions.
- Use the median, not the fastest result.
- Capture `_METHOD` and `CNTL=(showStages)` during an actual measured execution.
- Keep preparation time separate from query time.
- Drop/replace prior result tables consistently.
- Validate row counts, quantity totals, and missing enrichments.
- Randomize candidate order if cache effects appear material.

## Cost model

For a preparation cost `P`, unprepared median query time `Q0`, prepared median query time `Qp`, and `N` executions:

```text
unprepared total = N × Q0
prepared total   = P + N × Qp
break-even N     = P / (Q0 - Qp), when Qp < Q0
```

## Decision frame

Do not report a single winner without context. Name winners for:

- coding baseline;
- one-off execution;
- repeated execution;
- selective lookup;
- memory-constrained storage;
- overall production operation, including simplicity and rebuild cost.

The likely *starting point* is direct keys plus explicit columns. It is a hypothesis, not a result.
