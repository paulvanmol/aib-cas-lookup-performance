#!/usr/bin/env python3
"""Static completeness checks; this does not execute SAS."""
from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parents[1]
required = [
    "README.md", "config/config.example.sas", "docs/case-study.md",
    "docs/participant-lab.md", "docs/source-and-attribution.md",
    "programs/00_configure.sas", "programs/10_create_synthetic_data.sas",
    "programs/11_load_to_cas.sas", "programs/20_validate_inputs.sas",
    "programs/25_prepare_dimensions.sas", "programs/30_initialize_results.sas",
    "programs/40_dimension_size.sas", "programs/41_predicate_functions.sas",
    "programs/42_column_pruning.sas", "programs/43_partitioning.sas",
    "programs/44_indexes.sas", "programs/45_storage_formats.sas",
    "programs/46_finalists.sas", "programs/50_validate_results.sas",
    "programs/60_export_results.sas", "programs/run_all.sas",
]
missing = [p for p in required if not (root / p).is_file()]
if missing:
    print("Missing required files:", *missing, sep="\n- ")
    sys.exit(1)

sas_files = list((root / "programs").rglob("*.sas"))
joined = "\n".join(p.read_text(encoding="utf-8") for p in sas_files)
for token in ["_method", "showStages", "table.partition", "table.index",
              "memoryFormat=", "candidate=DVR", "compress=true", "median(ElapsedSec)"]:
    if token.lower() not in joined.lower():
        print(f"Required benchmark feature not found: {token}")
        sys.exit(1)

# Catch common merge damage: unbalanced macro definitions and unresolved build markers.
macro_starts = len(re.findall(r"%macro\b", joined, flags=re.I))
macro_ends = len(re.findall(r"%mend\b", joined, flags=re.I))
if macro_starts != macro_ends:
    print(f"Unbalanced SAS macro definitions: {macro_starts} starts, {macro_ends} ends")
    sys.exit(1)
if "TODO_BUILD" in joined:
    print("Unresolved TODO_BUILD marker")
    sys.exit(1)

print(f"PASS: {len(required)} required files and {len(sas_files)} SAS programs checked.")
