/* Requires config/config.sas to have been submitted first. */
%include "&PROJECT_ROOT/programs/00_configure.sas";

%macro maybe_generate;
  %if %upcase(&DATA_MODE)=SYNTHETIC %then %do;
    %include "&PROJECT_ROOT/programs/10_create_synthetic_data.sas";
  %end;
%mend;
%maybe_generate

%include "&PROJECT_ROOT/programs/11_load_to_cas.sas";
%include "&PROJECT_ROOT/programs/20_validate_inputs.sas";
%include "&PROJECT_ROOT/programs/25_prepare_dimensions.sas";
%include "&PROJECT_ROOT/programs/30_initialize_results.sas";
%include "&PROJECT_ROOT/programs/40_dimension_size.sas";
%include "&PROJECT_ROOT/programs/41_predicate_functions.sas";
%include "&PROJECT_ROOT/programs/42_column_pruning.sas";
%include "&PROJECT_ROOT/programs/43_partitioning.sas";
%include "&PROJECT_ROOT/programs/44_indexes.sas";
%include "&PROJECT_ROOT/programs/45_storage_formats.sas";
%include "&PROJECT_ROOT/programs/46_finalists.sas";
%include "&PROJECT_ROOT/programs/50_validate_results.sas";
%include "&PROJECT_ROOT/programs/60_export_results.sas";

%put NOTE: AIB CAS lookup-performance run completed.;
%put NOTE- Review CSV files under &PROJECT_ROOT/results.;
