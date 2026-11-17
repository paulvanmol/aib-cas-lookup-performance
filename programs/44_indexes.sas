/* Experiment 5: index build cost, full join, and selective join. */
%bench_start
proc cas;
  table.index /
    table={caslib="&CASLIB",name="customer_thin"},
    casout={caslib="&CASLIB",name="customer_indexed",indexVars={"CustomerID"},replace=true};
quit;
%bench_stop(experiment=Indexes,candidate=BUILD_CUSTOMER_INDEX,phase=PREP,rep=1,measured=1)
%table_details(customer_indexed)

%macro x5(candidate=,dim=,out=,selective=0);
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(&out)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..&out {options replace=true} as
      select o.OrderID,o.CustomerID,o.Quantity,u.CustomerName
      from &caslib..orders_raw o left join &caslib..&dim u on o.CustomerID=u.CustomerID
      %if &selective=1 %then %do;
        where o.CustomerID between 1 and &SELECTIVE_CUSTOMERS
      %end;
      ;
    quit;
    %bench_stop(experiment=Indexes,candidate=&candidate,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;
%x5(candidate=FULL_UNINDEXED,dim=customer_thin,out=x5_full_unindexed)
%x5(candidate=FULL_INDEXED,dim=customer_indexed,out=x5_full_indexed)
%x5(candidate=SELECTIVE_UNINDEXED,dim=customer_thin,out=x5_sel_unindexed,selective=1)
%x5(candidate=SELECTIVE_INDEXED,dim=customer_indexed,out=x5_sel_indexed,selective=1)
