/* Experiment 2: calculated join keys versus normalized direct keys. */
%macro x2_function;
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(x2_function_join)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..x2_function_join {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,c.Country_Name
      from &caslib..orders_raw o left join &caslib..country_thin c
        on upper(trim(o.Country))=upper(trim(c.Country));
    quit;
    %bench_stop(experiment=Predicate functions,candidate=COUNTRY_FUNCTION,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;

%macro x2_direct;
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(x2_direct_join)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..x2_direct_join {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,c.Country_Name
      from &caslib..orders_raw o left join &caslib..country_thin c on o.Country=c.Country;
    quit;
    %bench_stop(experiment=Predicate functions,candidate=COUNTRY_DIRECT,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;
%x2_function
%x2_direct
