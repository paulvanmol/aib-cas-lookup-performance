# AIB CAS Lookup Performance Lab

A reproducible SAS Viya/CAS workshop repository for testing lookup and join performance with an `ORDERS` fact table and `COUNTRYCODES`, `PRODUCTS`, and `CUSTOMERS` dimensions.

The scenario follows the schema and relative table sizes used in Mark Jordan's *Manipulating Data in Base SAS® Part 4 – Lookup*, but the repository does **not** redistribute the original data. It can either:

1. generate deterministic synthetic tables with the same schema and configurable scale; or
2. load the four original SAS data sets after you download and extract the public source package yourself.

## What is included

- Markdown case study and participant lab manual
- deterministic synthetic data generator
- external-source loader
- CAS configuration and validation programs
- repeatable FedSQL benchmarks for:
  - dimension size;
  - functions in join predicates;
  - column pruning and prepared attributes;
  - co-partitioning and break-even cost;
  - indexed full and selective workloads;
  - STANDARD, DVR, and compressed CAS tables;
- correctness checks and CSV result exports
- a static repository test

## Requirements

- SAS Viya with a CAS server and permission to create session-scope tables
- SAS Compute/SAS Studio access capable of submitting SAS programs
- a writable project checkout and CASLIB
- optional: the original four `.sas7bdat` files from the source ZIP

## Quick start

1. Clone or unzip this repository.
2. Copy `config/config.example.sas` to `config/config.sas`.
3. Edit `PROJECT_ROOT`, `CASLIB`, and the data/scale settings in `config/config.sas`.
4. In SAS Studio, submit:

   ```sas
   %include "/absolute/path/aib-cas-lookup-performance/config/config.sas";
   %include "&PROJECT_ROOT/programs/run_all.sas";
   ```

5. Review `results/benchmark_runs.csv`, `results/benchmark_summary.csv`, and `results/validation_summary.csv`.

Start with `DATA_PROFILE=DEMO` and `MEASURED_RUNS=1` for a smoke test. Use `WORKSHOP` and at least five measured runs for the lab. `SOURCE_SCALE` intentionally creates approximately 14.8 million orders and can consume substantial time and storage.

## Use original data instead

Download the package linked from the SAS Communities article, extract it, and set:

```sas
%let DATA_MODE=EXTERNAL;
%let SOURCE_DATA_DIR=/path/containing/orders.sas7bdat;
```

The loader checks for `ORDERS`, `COUNTRYCODES`, `PRODUCTS`, and `CUSTOMERS` before loading them to CAS.

## Run selected experiments

After `config/config.sas` and `programs/00_configure.sas` have been submitted, run programs in numeric order. Each experiment is independent after data load and dimension preparation. See [Running the programs](docs/running-the-programs.md).

## Important interpretation rule

There is no hard-coded winner. Compare elapsed time, execution stages, data movement, result size, preparation cost, and expected reuse. A good default coding baseline is direct keys plus only the required columns, but partitioning, indexes, DVR, and compression must be justified by measurements from your own CAS environment.

## Repository map

| Path | Purpose |
|---|---|
| `config/` | site and workload settings |
| `programs/` | data creation, loading, experiments, validation, export |
| `programs/macros/` | shared timing and CAS helper macros |
| `docs/` | case study, lab manual, schemas, interpretation guidance |
| `results/` | generated CSV evidence and a blank worksheet |
| `tests/` | static completeness checks |

## Source and licensing note

The original data and code are not included. See [Source and attribution](docs/source-and-attribution.md) and [Technical references](docs/references.md). This repository is workshop material; confirm your organization's requirements before adding a license or publishing it externally.
