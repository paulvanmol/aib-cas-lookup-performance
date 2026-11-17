/* Submit config/config.sas first. This overrides scale/run count for a smoke test. */
%let DATA_MODE=SYNTHETIC;
%let DATA_PROFILE=DEMO;
%let MEASURED_RUNS=1;
%let SELECTIVE_CUSTOMERS=100;
%let CAPTURE_SHOWSTAGES=Y;
%include "&PROJECT_ROOT/programs/run_all.sas";
