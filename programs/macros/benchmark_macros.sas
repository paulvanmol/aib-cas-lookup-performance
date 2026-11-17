/* Shared benchmark helpers. Requires config and WORK.BENCHMARK_RUNS. */
%macro bench_start;
  %global _bench_started;
  %let _bench_started=%sysfunc(datetime());
%mend;

%macro bench_stop(experiment=, candidate=, phase=QUERY, rep=., measured=1, notes=);
  %local _elapsed;
  %let _elapsed=%sysevalf(%sysfunc(datetime())-&_bench_started);
  data work._benchmark_one;
    length Experiment $40 Candidate $64 Phase $8 Notes $240;
    format Timestamp e8601dt26.3 ElapsedSec 14.3;
    Experiment="&experiment";
    Candidate="&candidate";
    Phase="&phase";
    Rep=&rep;
    Measured=&measured;
    ElapsedSec=&_elapsed;
    Timestamp=datetime();
    Notes="&notes";
  run;
  proc append base=work.benchmark_runs data=work._benchmark_one force; run;
  proc datasets library=work nolist; delete _benchmark_one; quit;
%mend;

%macro plan_opts(rep);
  %if &rep=1 and %upcase(&CAPTURE_SHOWSTAGES)=Y %then %do;
    _method cntl=(showStages)
  %end;
%mend;

%macro drop_cas(name);
  proc cas;
    table.dropTable / caslib="&CASLIB", name="&name", quiet=true;
  quit;
%mend;

%macro table_details(name);
  proc cas;
    table.tableDetails / caslib="&CASLIB", name="&name";
  quit;
%mend;
