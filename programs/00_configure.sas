/* Validate configuration, select scale, and connect to CAS. */
%macro require_macro(name);
  %if not %symexist(&name) %then %do;
    %put ERROR: Required macro variable &name is not defined.;
    %abort cancel;
  %end;
%mend;

%macro configure_values;
  %global ACTIVE_DATA_DIR ORDER_ROWS CUSTOMER_ROWS PRODUCT_ROWS COUNTRY_ROWS;
  %require_macro(PROJECT_ROOT)
  %require_macro(CAS_SESSION)
  %require_macro(CASLIB)
  %require_macro(DATA_MODE)
  %require_macro(DATA_PROFILE)
  %require_macro(MEASURED_RUNS)

  %if %upcase(&DATA_MODE)=SYNTHETIC %then %let ACTIVE_DATA_DIR=&PROJECT_ROOT/data/generated;
  %else %if %upcase(&DATA_MODE)=EXTERNAL %then %let ACTIVE_DATA_DIR=&SOURCE_DATA_DIR;
  %else %do;
    %put ERROR: DATA_MODE must be SYNTHETIC or EXTERNAL.;
    %abort cancel;
  %end;

  %if %upcase(&DATA_PROFILE)=DEMO %then %do;
    %let ORDER_ROWS=100000;
    %let CUSTOMER_ROWS=10000;
    %let PRODUCT_ROWS=70;
  %end;
  %else %if %upcase(&DATA_PROFILE)=WORKSHOP %then %do;
    %let ORDER_ROWS=2000000;
    %let CUSTOMER_ROWS=200000;
    %let PRODUCT_ROWS=700;
  %end;
  %else %if %upcase(&DATA_PROFILE)=SOURCE_SCALE %then %do;
    %let ORDER_ROWS=14846132;
    %let CUSTOMER_ROWS=1099519;
    %let PRODUCT_ROWS=700;
  %end;
  %else %if %upcase(&DATA_PROFILE)=CUSTOM %then %do;
    %let ORDER_ROWS=&CUSTOM_ORDER_ROWS;
    %let CUSTOMER_ROWS=&CUSTOM_CUSTOMER_ROWS;
    %let PRODUCT_ROWS=&CUSTOM_PRODUCT_ROWS;
  %end;
  %else %do;
    %put ERROR: DATA_PROFILE must be DEMO, WORKSHOP, SOURCE_SCALE, or CUSTOM.;
    %abort cancel;
  %end;
  %let COUNTRY_ROWS=17;
%mend;
%configure_values

options msglevel=i fullstimer source2 mprint;
libname lookup "&ACTIVE_DATA_DIR";

cas &CAS_SESSION sessopts=(caslib="&CASLIB" metrics=true timeout=&CAS_TIMEOUT);
libname mycas cas sessref=&CAS_SESSION caslib="&CASLIB";

%include "&PROJECT_ROOT/programs/macros/benchmark_macros.sas";

%put NOTE: AIB CAS lab configured.;
%put NOTE- DATA_MODE=&DATA_MODE DATA_PROFILE=&DATA_PROFILE;
%put NOTE- ORDERS=&ORDER_ROWS CUSTOMERS=&CUSTOMER_ROWS PRODUCTS=&PRODUCT_ROWS COUNTRIES=&COUNTRY_ROWS;
%put NOTE- MEASURED_RUNS=&MEASURED_RUNS CASLIB=&CASLIB;
