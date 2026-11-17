# Running the programs

## Full run

```sas
%include "/absolute/path/aib-cas-lookup-performance/config/config.sas";
%include "&PROJECT_ROOT/programs/run_all.sas";
```

`run_all.sas` performs these steps:

1. configure the CAS session and helper macros;
2. generate synthetic data when `DATA_MODE=SYNTHETIC`;
3. load four source tables to CAS;
4. validate schemas and key uniqueness;
5. prepare thin dimensions;
6. initialize benchmark capture;
7. run all experiments;
8. validate the final outputs;
9. export detailed and median result CSVs.

## Individual run order

| Program | Purpose |
|---|---|
| `00_configure.sas` | connect and define libraries/macros |
| `10_create_synthetic_data.sas` | create deterministic Base SAS source tables |
| `11_load_to_cas.sas` | load source or external data |
| `20_validate_inputs.sas` | schema, rows, and duplicate-key checks |
| `25_prepare_dimensions.sas` | precompute `CustomerName` and prune columns |
| `30_initialize_results.sas` | reset timing capture |
| `40_dimension_size.sas` | country/product/customer plans |
| `41_predicate_functions.sas` | function vs direct predicate |
| `42_column_pruning.sas` | wide vs lean projection |
| `43_partitioning.sas` | partition build plus repeated query |
| `44_indexes.sas` | full and selective indexed joins |
| `45_storage_formats.sas` | STANDARD, DVR, compression |
| `46_finalists.sas` | baseline and combined prepared candidate |
| `50_validate_results.sas` | correctness signatures |
| `60_export_results.sas` | CSV export and medians |

## Logs and plans

The first measured repetition of each candidate runs with `_METHOD CNTL=(showStages)`. Search the SAS log for:

- `HashJoin`, `MergeJoin`, `Sort`, and `SeqScan`;
- number of sorts and joins;
- data access threads;
- rows/columns entering and leaving stages;
- time to replicate, partition, sort, or open tables.

## Safe smoke test

Use:

```sas
%let DATA_MODE=SYNTHETIC;
%let DATA_PROFILE=DEMO;
%let MEASURED_RUNS=1;
%let SELECTIVE_CUSTOMERS=100;
```

A smoke test verifies execution, not performance. For conclusions, increase row counts and measured runs.
