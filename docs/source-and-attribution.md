# Source and attribution

This workshop is inspired by Mark Jordan's SAS Communities article, [Manipulating Data in Base SAS® Part 4 – Lookup](https://communities.sas.com/t5/SAS-Communities-Library/Manipulating-Data-in-Base-SAS-Part-4-Lookup/ta-p/938676), and its linked package:

- <https://github.com/SASJedi/blogPackages/blob/main/data_manipulation_in_base_sas.zip>

The article documents these source characteristics:

| Table | Rows | Columns | Approximate size |
|---|---:|---:|---:|
| `COUNTRYCODES` | 17 | 2 | 0.3 MB |
| `PRODUCTS` | 700 | 4 | 0.3 MB |
| `CUSTOMERS` | 1,099,519 | 12 | 149.9 MB |
| `ORDERS` | 14,846,132 | 6 | 952.6 MB |

The article compares DATA step merge, hash object, formats, PROC SQL, and PROC FedSQL lookups. This repository applies the same fact/dimension shape to a CAS-focused experiment on direct predicates, narrow projections, partitioning, indexes, DVR, and compression.

## What is and is not redistributed

- The original ZIP, data, and programs are **not** included.
- `10_create_synthetic_data.sas` creates new deterministic synthetic values with the documented schema and configurable row counts.
- `11_load_to_cas.sas` can load the original data if the participant obtains and extracts it separately.
- Product, customer, address, and order values generated here are fictional and are not copied from the source package.

## Verification note

The public article was used to verify column names, sample structures, and documented row counts. The ZIP itself could not be fetched in the build environment, so run `20_validate_inputs.sas` against the extracted original data before a workshop. If a local source uses different types or lengths, align the generator-independent joins in `40`–`45` with the validated schema.
