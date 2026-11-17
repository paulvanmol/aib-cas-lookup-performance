/* Experiment 6: create equivalent STANDARD, DVR, and compressed tables. */
%macro make_copy(candidate=,name=,format=STANDARD,compress=false);
  %bench_start
  proc cas;
    table.copyTable /
      table={caslib="&CASLIB",name="x3_lean"},
      casout={caslib="&CASLIB",name="&name",memoryFormat="&format",compress=&compress,replace=true};
  quit;
  %bench_stop(experiment=Storage formats,candidate=&candidate._COPY,phase=PREP,rep=1,measured=1)
%mend;
%make_copy(candidate=STANDARD,name=result_standard,format=STANDARD,compress=false)
%make_copy(candidate=DVR,name=result_dvr,format=DVR,compress=false)
%make_copy(candidate=COMPRESSED,name=result_compressed,format=STANDARD,compress=true)

%table_details(result_standard)
%table_details(result_dvr)
%table_details(result_compressed)

%macro summarize(candidate=,source=,out=);
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(&out)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..&out {options replace=true} as
      select Country_Name,Manufacturer,sum(Quantity) as Units
      from &caslib..&source group by Country_Name,Manufacturer;
    quit;
    %bench_stop(experiment=Storage formats,candidate=&candidate,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;
%summarize(candidate=STANDARD,source=result_standard,out=sum_standard)
%summarize(candidate=DVR,source=result_dvr,out=sum_dvr)
%summarize(candidate=COMPRESSED,source=result_compressed,out=sum_compressed)
