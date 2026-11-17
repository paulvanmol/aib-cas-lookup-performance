/* Copy to config/config.sas and edit for your environment. */
%let PROJECT_ROOT=/home/sas/aib_cas_lookup_performance;

/* CAS settings */
%let CAS_SESSION=mysession;
%let CASLIB=DM;
%let CAS_TIMEOUT=1800;

/* SYNTHETIC or EXTERNAL */
%let DATA_MODE=SYNTHETIC;
%let SOURCE_DATA_DIR=&PROJECT_ROOT/data/source;

/* DEMO, WORKSHOP, SOURCE_SCALE, or CUSTOM */
%let DATA_PROFILE=DEMO;
%let CUSTOM_ORDER_ROWS=100000;
%let CUSTOM_CUSTOMER_ROWS=10000;
%let CUSTOM_PRODUCT_ROWS=70;
%let RANDOM_SEED=271828;

/* Benchmark controls */
%let MEASURED_RUNS=1;
%let SELECTIVE_CUSTOMERS=100;
%let CAPTURE_SHOWSTAGES=Y;
%let KEEP_EXPERIMENT_TABLES=Y;
